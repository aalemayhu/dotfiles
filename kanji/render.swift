// Draws one kanji big with text lines under it, centered in a cols x rows screen.
//   render [--image dark|light] <kanji> <cols> <rows> [line ...]
// By default the kanji is half-block art, which works in any terminal. --image sends a smooth
// PNG over the kitty graphics protocol instead (Ghostty, kitty, WezTerm; zellij passes it on),
// with ink for a dark or light background. Lines may hold ANSI colors; they are left out of the
// width. Uses only macOS (CoreText, ImageIO, Hiragino and the textbook-style YuKyokasho).
// kanji/kanji compiles this on first use.
import CoreGraphics
import CoreText
import Foundation
import ImageIO

var args = Array(CommandLine.arguments.dropFirst())
var image: String?
if args.first == "--image" { image = args[1]; args.removeFirst(2) }
let ch = args[0], cols = Int(args[1])!, rows = Int(args[2])!
let text = Array(args.dropFirst(3))

func visible(_ s: String) -> String {
    s.replacingOccurrences(of: "\u{1b}\\[[0-9;]*m", with: "", options: .regularExpression)
}

// East Asian wide characters take two terminal columns
func width(_ s: String) -> Int {
    visible(s).unicodeScalars.reduce(0) { w, u in
        let v = u.value
        let wide = (0x1100...0x115f).contains(v) || (0x2e80...0xa4cf).contains(v) || (0xac00...0xd7a3).contains(v)
            || (0xf900...0xfaff).contains(v) || (0xfe30...0xfe4f).contains(v) || (0xff00...0xff60).contains(v)
            || (0xffe0...0xffe6).contains(v)
        return w + (wide ? 2 : 1)
    }
}

func centered(_ s: String) -> String {
    String(repeating: " ", count: max(0, (cols - width(s)) / 2)) + s + "\u{1b}[0m"
}

func line(_ ch: String, font: String, size: CGFloat, color: CGColor? = nil) -> CTLine {
    var attrs: [NSAttributedString.Key: Any] = [.init(kCTFontAttributeName as String): CTFontCreateWithName(font as CFString, size, nil)]
    if let color { attrs[.init(kCTForegroundColorAttributeName as String)] = color }
    else { attrs[.init(kCTForegroundColorFromContextAttributeName as String)] = true }
    return CTLineCreateWithAttributedString(NSAttributedString(string: ch, attributes: attrs))
}

// Rasterize the glyph about S pixels tall into a W x H alpha grid, top row first
func glyph(_ ch: String, _ S: Int) -> [[Bool]] {
    let W = 2 * S, H = 2 * S
    var px = [UInt8](repeating: 0, count: W * H)
    let ctx = CGContext(data: &px, width: W, height: H, bitsPerComponent: 8, bytesPerRow: W,
                        space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    ctx.setFillColor(gray: 1, alpha: 1)
    ctx.textPosition = CGPoint(x: S / 2, y: S / 2)
    CTLineDraw(line(ch, font: "HiraginoSans-W3", size: CGFloat(S)), ctx)
    return (0..<H).map { y in (0..<W).map { x in px[y * W + x] > 128 } }
}

// Crop to the ink and pack two pixel rows into each line with ▀ ▄ █
func art(_ on: [[Bool]]) -> [String] {
    let ys = on.indices.filter { on[$0].contains(true) }
    let xs = on[0].indices.filter { x in on.contains { $0[x] } }
    guard let y0 = ys.first, let y1 = ys.last, let x0 = xs.first, let x1 = xs.last else { return [] }
    return stride(from: y0, through: y1, by: 2).map { y in
        var s = ""
        for x in x0...x1 {
            let top = on[y][x], bottom = y + 1 <= y1 && on[y + 1][x]
            s += top && bottom ? "█" : top ? "▀" : bottom ? "▄" : " "
        }
        while s.hasSuffix(" ") { s.removeLast() }
        return s
    }
}

func blocks() -> String {
    // square pixels: one column is one pixel wide, one row two pixels high
    let S = max(8, min(cols - 4, 2 * (rows - text.count - 2), 80))
    let drawn = art(glyph(ch, S))
    let pad = String(repeating: " ", count: max(0, cols - (drawn.map(\.count).max() ?? 0)) / 2)
    let out = drawn.map { pad + $0 } + [""] + text.map(centered)
    return String(repeating: "\n", count: max(0, (rows - out.count) / 2)) + out.joined(separator: "\n")
}

// The glyph centered on a transparent square PNG
func png(_ ch: String, ink: CGColor) -> Data {
    let S = 512
    let ctx = CGContext(data: nil, width: S, height: S, bitsPerComponent: 8, bytesPerRow: 0,
                        space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    let l = line(ch, font: "YuKyo-Medium", size: CGFloat(S) * 0.85, color: ink)
    let b = CTLineGetImageBounds(l, ctx)
    ctx.textPosition = CGPoint(x: (CGFloat(S) - b.width) / 2 - b.minX, y: (CGFloat(S) - b.height) / 2 - b.minY)
    CTLineDraw(l, ctx)
    let data = NSMutableData()
    let dst = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil)!
    CGImageDestinationAddImage(dst, ctx.makeImage()!, nil)
    CGImageDestinationFinalize(dst)
    return data as Data
}

func kitty(_ mode: String) -> String {
    // cell height / width, from the pty's pixel size when the terminal reports it
    var ws = winsize()
    let ratio = ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == 0 && ws.ws_xpixel > 0 && ws.ws_ypixel > 0
        ? (Double(ws.ws_ypixel) / Double(rows)) / (Double(ws.ws_xpixel) / Double(cols)) : 2.1
    var r = rows - text.count - 3
    var c = Int((Double(r) * ratio).rounded())
    if c > cols - 4 { c = cols - 4; r = Int((Double(c) / ratio).rounded()) }
    let top = max(0, (rows - r - 1 - text.count) / 2), left = max(0, (cols - c) / 2)
    let ink = mode == "light" ? CGColor(red: 0.13, green: 0.13, blue: 0.15, alpha: 1)
                              : CGColor(red: 0.93, green: 0.93, blue: 0.89, alpha: 1)
    // sent in 4096-byte chunks; C=1 leaves the cursor where the image starts
    let b64 = Array(png(ch, ink: ink).base64EncodedString())
    var out = "\u{1b}[\(top + 1);\(left + 1)H"
    for (i, start) in stride(from: 0, to: b64.count, by: 4096).enumerated() {
        let chunk = String(b64[start..<min(start + 4096, b64.count)])
        let more = start + 4096 < b64.count ? 1 : 0
        let keys = i == 0 ? "a=T,f=100,q=2,C=1,c=\(c),r=\(r),m=\(more)" : "m=\(more)"
        out += "\u{1b}_G\(keys);\(chunk)\u{1b}\\"
    }
    out += "\u{1b}[\(top + r + 2);1H" + text.map(centered).joined(separator: "\n")
    return out
}

print(image.map(kitty) ?? blocks())
