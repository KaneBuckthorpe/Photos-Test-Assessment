//
//  PhotoViewerUIHelper.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 22/08/2022.
//

import UIKit
import func AVFoundation.AVMakeRect

enum PhotoViewerUIHelper {
    static func aspectScaledToFillFrame(for image: UIImage, inVisbleRect visibleRect: CGRect) -> CGRect {
        assert(visibleRect.width.isNormal && visibleRect.height.isNormal,
               "You cannot safely scale an image with nonNormal width or height")
        var scaledImageRect = CGRect.zero

        let imageAspectRatio = image.size.width / image.size.height
        let canvasAspectRatio = visibleRect.width / visibleRect.height

        var aspectRatio: CGFloat

        if imageAspectRatio > canvasAspectRatio {
            aspectRatio = visibleRect.height / image.size.height
        } else {
            aspectRatio = visibleRect.width / image.size.width
        }

        scaledImageRect.size.width = image.size.width * aspectRatio
        scaledImageRect.size.height = image.size.height * aspectRatio
        scaledImageRect.origin.x = (visibleRect.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (visibleRect.height - scaledImageRect.size.height) / 2.0
        
        return scaledImageRect
    }
    
    static func visibleImageRect(container: UIView, contentMode: PhotoViewImageContentMode, imageView: UIImageView) -> CGRect {

        var visibleRect: CGRect
        switch contentMode {
        case .scaleAspectFit:
            visibleRect = rectforImage(in: imageView)

        case .scaleAspectFill:
            visibleRect = container.convert(container.bounds, to: imageView)
        }
        return visibleRect
    }
    
    static func transform(forSalientRegionView view: UIView) -> CGAffineTransform {
        let scaleT = CGAffineTransform(scaleX: view.bounds.width, y: -view.bounds.height)
        let translateT = CGAffineTransform(translationX: 0, y: view.bounds.height)
        return scaleT.concatenating(translateT)
    }
    
    private static func rectforImage(in imageView: UIImageView) -> CGRect {
        guard let image = imageView.image else { return .zero }
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        return rect
    }
}
