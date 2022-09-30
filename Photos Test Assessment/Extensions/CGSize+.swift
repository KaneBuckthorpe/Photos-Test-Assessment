//
//  CGSize+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 30/09/2022.
//

import UIKit

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
