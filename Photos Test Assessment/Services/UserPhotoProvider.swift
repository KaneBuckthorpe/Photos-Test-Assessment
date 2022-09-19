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
    private let localIdentifier: String
    var handler: ((UIImage?) -> Void)?
    
    init(cache: PHCachingImageManager, localIdentifier: String) {
        self.cache = cache
        self.localIdentifier = localIdentifier
    }
    
    func loadImage(size: CGSize) {
        guard let asset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: .none).firstObject
        else {
            handler?(nil)
            return
        }
        
        cache.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            self?.handler?(image)
        }
    }
}
