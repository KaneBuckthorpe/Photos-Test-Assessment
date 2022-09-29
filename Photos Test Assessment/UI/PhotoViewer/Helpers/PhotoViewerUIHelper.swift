//
//  PhotoViewerUIHelper.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 22/08/2022.
//

import UIKit

enum PhotoViewerUIHelper {    
    static func visibleImageRect(container: UIView, contentMode: PhotoViewImageContentMode, imageView: UIImageView) -> CGRect {

        var visibleRect: CGRect
        switch contentMode {
        case .scaleAspectFit:
            visibleRect = imageView.image?.size.aspectFitRect(for: imageView.bounds.size) ?? .zero

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
}

extension CGSize {
    func aspectFitRect(for size: CGSize) -> CGRect {
        let aspectFitSize = self.aspectFitSize(for: size)
        let xPos = (size.width - aspectFitSize.width) / 2
        let yPos = (size.height - aspectFitSize.height) / 2
        let rect = CGRect(x: xPos, y: yPos, width: aspectFitSize.width, height: aspectFitSize.height)
        return rect
    }
    
    func aspectFillRect(for size: CGSize) -> CGRect {
        let aspectFillSize = self.aspectFillSize(for: size)
        let xPos = (size.width - aspectFillSize.width) / 2
        let yPos = (size.height - aspectFillSize.height) / 2
        let rect = CGRect(x: xPos, y: yPos, width: aspectFillSize.width, height: aspectFillSize.height)
        return rect
    }
}

extension CGSize {
    func aspectFitSize(for size: CGSize) -> CGSize {
        let mW = size.width / self.width;
        let mH = size.height / self.height;
        
        var result = size
        if (mH < mW) {
            result.width = mH * self.width;
        } else if (mW < mH) {
            result.height = mW * self.height;
        }
        
        return result
    }
    
    func aspectFillSize(for size: CGSize) -> CGSize {
        let mW = size.width / self.width;
        let mH = size.height / self.height;
        
        var result = size
        if (mH > mW) {
            result.width = mH * self.width;
        } else if (mW > mH) {
            result.height = mW * self.height;
        }
        return result
    }
}

