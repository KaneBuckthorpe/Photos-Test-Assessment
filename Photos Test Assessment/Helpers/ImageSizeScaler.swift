//
//  ImageSizeScaler.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

enum ImageSizeScaler {
    static func imageSize(for view: UIView) -> CGSize {
        let viewSize = view.bounds.size
        let scale = view.traitCollection.displayScale
        let targetSize = CGSize(width: viewSize.width * scale, height: viewSize.height * scale)
        return targetSize
    }
}
