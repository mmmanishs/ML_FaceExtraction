//
//  main.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/13/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import Vision
import AppKit

// Input Directory: Folders with images are expected in this folder
let splitOutput = "/Users/manishsingh/Desktop/Extract/Input"
let movie1 = "/Users/manishsingh/Desktop/Extract/Manish.MOV"
let movie2 = "/Users/manishsingh/Desktop/Extract/Person2.MOV"

// Pass all the parameters in the command line and handle folder creation and deletion

func main() {
    let processArguments = ProcessInfo().arguments
    guard processArguments.count == 3 else {
        print("Unexpected number of arguments")
        print("Valid example")
        print("programName inputDirectory outputDirectory")
        return
    }
    let processPath = processArguments[0]
    let inputDir = processArguments[1]
    let outputDir = processArguments[2]
    
    let scriptPath = processPath._cd__() + "/split.sh"
    let bashCommand = "sh \(scriptPath) \(splitOutput) \(movie1) \(movie2)"
    shell(bashCommand)
    startEvents(inputDir: inputDir, outputDir: outputDir)
}

main()
