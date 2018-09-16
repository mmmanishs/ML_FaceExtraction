//
//  Shell.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/15/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//
// https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild

import Foundation

func shell(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    task.waitUntilExit()
    return output
}
