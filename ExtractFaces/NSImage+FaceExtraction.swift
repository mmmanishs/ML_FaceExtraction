//
//  FaceCropper.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/13/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import Vision
import AppKit

extension NSImage {
    func extractFace(completion: @escaping ([NSImage]) -> ()) {
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest() { request, error in
            guard let observations = request.results as? [VNFaceObservation] else {
                fatalError("unexpected result type!")
            }
            var faceImages = [NSImage]()
            for face in observations {
                let normalizedBox = self.normalizeRect(rect: face.boundingBox)
                if let faceImage = self.crop(rect: normalizedBox) {
                    faceImages.append(faceImage)
                }
            }
            completion(faceImages)
        }
        let requestHandler = VNImageRequestHandler(cgImage: cgimage, orientation: CGImagePropertyOrientation(rawValue: 0)!, options: [:])
        try? requestHandler.perform([faceLandmarksRequest])
    }
}

extension NSImage {
    var cgimage: CGImage {
        return cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }
    
    var ciimage: CIImage? {
        return CIImage(cgImage: cgimage)
    }
    
    func normalizeRect(rect: CGRect) -> CGRect {
        var toRect = CGRect()
        toRect.size.width = rect.size.width * size.width
        toRect.size.height = rect.size.height * size.height
        toRect.origin.y =  (size.height) - (size.height * rect.origin.y )
        toRect.origin.y  = toRect.origin.y -  toRect.size.height
        toRect.origin.x =  rect.origin.x * size.width
        return toRect
    }
    
    func crop(rect: CGRect) -> NSImage? {
        guard let croppedImage = ciimage?.cropped(to: rect) else {
            return nil
        }
        let rep: NSCIImageRep = NSCIImageRep(ciImage: croppedImage)
        let nsImage: NSImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
}
