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

class FaceCropper {
    static func getFaces(from image: NSImage, completion: @escaping ([NSImage]) -> ()) {
        var orientation:Int32 = 0
        //
        //        // detect image orientation, we need it to be accurate for the face detection to work
        //        switch image.imageOrientation {
        //        case .up:
        //            orientation = 1
        //        case .right:
        //            orientation = 6
        //        case .down:
        //            orientation = 3
        //        case .left:
        //            orientation = 8
        //        default:
        //            orientation = 1
        //        }
        
        // vision
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest() { request, error in
            guard let observations = request.results as? [VNFaceObservation] else {
                fatalError("unexpected result type!")
            }
            var faceImages = [NSImage]()
            for face in observations {
                let faceCGRect = image.transformRect(fromRect: face.boundingBox)
                let nssize = NSSize(width: faceCGRect.size.width, height: faceCGRect.size.height)
                if let faceImage = image.crop(toSize: nssize) {
                    faceImages.append(faceImage)
                }
            }
            completion(faceImages)
        }
        let requestHandler = VNImageRequestHandler(cgImage: image.cgimage, orientation: CGImagePropertyOrientation(rawValue: 0)!, options: [:])
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
    }
    
    static func handleFaceFeatures(request: VNRequest, errror: Error?) {
    }
    
}

extension NSImage {
    var cgimage: CGImage {
        return cgImage(forProposedRect: nil, context: nil, hints: nil)!
    }
    
    var ciimage: CIImage? {
        return CIImage(cgImage: cgimage)
    }
    
    func transformRect(fromRect: CGRect) -> CGRect {
        var toRect = CGRect()
        toRect.size.width = fromRect.size.width * size.width
        toRect.size.height = fromRect.size.height * size.height
        toRect.origin.y =  (size.height) - (size.height * fromRect.origin.y )
        toRect.origin.y  = toRect.origin.y -  toRect.size.height
        toRect.origin.x =  fromRect.origin.x * size.width
        return toRect
    }
    
//    func crop(toSize rect: CGRect) -> NSImage?  {
//        let targetSize = NSSize(width: rect.size.width, height: rect.size.height)
//
//        guard let resizedImage = self.resizeMaintainingAspectRatio(withSize: targetSize) else {
//            return nil
//        }
//        let x = floor((resizedImage.size.width - targetSize.width) / 2)
//        let y = floor((resizedImage.size.height - targetSize.height) / 2)
//        let frame = NSRect(x: x, y: y, width: targetSize.width, height: targetSize.height)
//
//        guard let representation = resizedImage.bestRepresentation(for: frame, context: nil, hints: nil) else {
//            return nil
//        }
//
//        let image = NSImage(size: targetSize,
//                            flipped: false,
//                            drawingHandler: { (destinationRect: NSRect) -> Bool in
//                                return representation.draw(in: destinationRect)
//        })
//
//        return image
//    }
//
//
//    func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
//        guard let resizedImage = self.resizeMaintainingAspectRatio(withSize: targetSize) else {
//            return nil
//        }
//        let newSize: NSSize
//        let widthRatio  = targetSize.width / self.size.width
//        let heightRatio = targetSize.height / self.size.height
//
//        if widthRatio > heightRatio {
//            newSize = NSSize(width: floor(self.size.width * widthRatio),
//                             height: floor(self.size.height * widthRatio))
//        } else {
//            newSize = NSSize(width: floor(self.size.width * heightRatio),
//                             height: floor(self.size.height * heightRatio))
//        }
//        return self.resize(withSize: newSize)
//    }
//
//    func resize(withSize targetSize: NSSize) -> NSImage? {
//        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
//        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
//            return nil
//        }
//        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
//            return representation.draw(in: frame)
//        })
//
//        return image
//    }
}

extension CIImage {
    func perspectiveCorrection(withrect rect: CGRect) -> CIImage {
        let topLeft = CGPoint(x: rect.origin.x, y: rect.origin.y)
        let topRight = CGPoint(x: rect.origin.x, y: (rect.origin.x + rect.size.width))
        let bottomLeft = CGPoint(x: rect.origin.x, y: (rect.origin.y + rect.size.height))
        let bottomRight = CGPoint(x: (rect.origin.x + rect.size.width), y: (rect.origin.y + rect.size.height))
        return applyingFilter("CIPerspectiveCorrection", parameters: [
            "inputTopLeft":    CIVector(cgPoint: topLeft),
            "inputTopRight":   CIVector(cgPoint: topRight),
            "inputBottomLeft": CIVector(cgPoint: bottomLeft),
            "inputBottomRight":CIVector(cgPoint: bottomRight)])
    }
}


//func crop(rect: CGRect) -> NSImage? {
//    self.cro
//    //        let croppedImage = ciimage!.perspectiveCorrection(withrect: rect)
//    //        var rep: NSCIImageRep = NSCIImageRep(ciImage: croppedImage)
//    //        var nsImage: NSImage = NSImage(size: rep.size)
//    //        nsImage.addRepresentation(rep)
//    //        return nsImage
//}
