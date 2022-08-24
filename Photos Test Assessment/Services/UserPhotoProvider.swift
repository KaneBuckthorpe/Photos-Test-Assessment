//
//  UserPhotoViewerImageProvider.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit
import Photos

class UserPhotoProvider: PhotoViewerImageProvider {
    private let cache: PHCachingImageManager
    private let asset: PHAsset
    var handler: ((UIImage?) -> Void)?
    
    init(cache: PHCachingImageManager, asset: PHAsset) {
        self.cache = cache
        self.asset = asset
    }
    
    func loadImage(size: CGSize) {
        cache.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            self?.handler?(image)
        }
    }
}
