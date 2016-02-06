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

func configure() { 
	shell("/bin/echo", "\(__FUNCTION__) is not implemented yet")
	// TODO: Load directories file
	// TODO: Create directories
}

func copy_config_files() {
	shell("/bin/echo", "\(__FUNCTION__) is not implemented yet")
	//TODO: Copy files over
	//TODO: Download missing repositories
}

func extras() {
	shell("/bin/echo", "\(__FUNCTION__) is not implemented yet")
	//TODO: Create ssh-key
	// install homebrew if applicable
}

func main() {
	configure()
	copy_config_files()
	extras()
}

main()
