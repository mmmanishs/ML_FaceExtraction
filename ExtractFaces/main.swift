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

var mainDirectory = "/Users/manishsingh/Desktop/Extract/"

func main() {
    guard let images = FileHandler.getImages(atPath: mainDirectory) else {
        return
    }
    
    for image in images {
        FaceCropper.getFaces(from: image) { faces in
            FileHandler.saveImage(image: faces[0], named: "my_face.png", toDirectory: mainDirectory)
        }
    }
}

main()
