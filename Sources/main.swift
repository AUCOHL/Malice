/*
    Malice Boostrap

    Copyright (C) 2018 Cloud V

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
