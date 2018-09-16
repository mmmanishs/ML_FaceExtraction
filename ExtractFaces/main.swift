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
var inputDirectory = "/Users/manishsingh/Desktop/Extract/Input"

// Output Directory: Cropped face images will be put here, in the folders from which they were extracted from (Folders in the Input directory)
let outputDirectoryHomePath = "/Users/manishsingh/Desktop/Extract/Output"

func main() {
    let processArguments = ProcessInfo().arguments
    guard processArguments.count != 3 else {
        print("Unexpected number of arguments")
        print("Valid example")
        print("programName inputDirectory outputDirectory")
        return
    }
    let processPath = processArguments[0]
    let inputDir = processArguments[1]
    let outputDir = processArguments[2]
    startEvents(inputDir: inputDir, outputDir: outputDir)
}

main()
