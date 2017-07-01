//Bootstrap for macOS

import Foundation

print("Running bootstrap...")

guard let path = Bundle.main.url(forResource: "Termites", withExtension: "txt")
else
{
    print("Could not find locus.")
    exit(0)
}

let folderURL = path.deletingLastPathComponent().deletingLastPathComponent()
let directory = folderURL.path

let task = Process()
task.launchPath = "/usr/bin/env"
task.arguments = ["bash", "-c", "cd \(directory) ; ./usr/bin/Malice"]

let pipe = Pipe()
task.standardOutput = pipe
task.standardError = pipe

task.launch()
let data = pipe.fileHandleForReading.readDataToEndOfFile()
let output = String(data: data, encoding: .utf8)

task.waitUntilExit()

print(output!)
