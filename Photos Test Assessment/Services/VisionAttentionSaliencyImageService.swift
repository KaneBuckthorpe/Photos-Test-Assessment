//
//  VisionAttentionSaliencyImageService.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 22/08/2022.
//

import Foundation
import Vision

class VisionAttentionSaliencyImageService: AttentionSaliencyImageService {
    func requestSalienceObjectBoundingRect(forImage image: CGImage, regionOfInterest: CGRect?, transfrom: CGAffineTransform) -> CGRect {
        let request = VNGenerateAttentionBasedSaliencyImageRequest()
        #if targetEnvironment(simulator)
            request.usesCPUOnly = true
        #endif
        let handler = VNImageRequestHandler(cgImage: image)
        if let regionOfInterest = regionOfInterest {
            request.regionOfInterest = regionOfInterest.applying(transfrom.inverted())
        }
        
        let fallback = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        do {
            try handler.perform([request])
        } catch {
            return fallback
        }

        let result = request.results?.first as? VNSaliencyImageObservation
        let salienceBoundingBox = result?.salientObjects?.first?.boundingBox ?? fallback
        return salienceBoundingBox.applying(transfrom)
    }
}
