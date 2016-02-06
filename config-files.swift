#!/usr/bin/env swift

import Foundation

// http://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
func shell(args: String...) -> Int32 {
    let task = NSTask()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

shell("ls")
