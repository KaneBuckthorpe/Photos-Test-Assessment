//
//  UserPhotosListProvider.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit
import Photos

enum UserPhotosThumbnailsProviderError: Error {
    case invalidPhotosAuthorization
}

class UserPhotosListProvider: PhotosGridImagesProvider {
    
    let cache: PHCachingImageManager
    
    private lazy var allPhotos: PHFetchResult = {
        let mostRecentMedia = PHFetchOptions()
        mostRecentMedia.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        mostRecentMedia.fetchLimit = 1000
        let allPhotos = PHAsset.fetchAssets(with: .image, options: mostRecentMedia)
        return allPhotos
    }()
    
    var numberOfImages: Int { allPhotos.count }
    
    init(cache: PHCachingImageManager = .init()) {
        self.cache = cache
    }
    
    func load() async throws {
        try await requestPhotosAccess()
    }
    
    func assetForItem(number: Int) -> PHAsset {
        allPhotos.object(at: number)
    }
    
    func imageForItem(_ number: Int, targetSize: CGSize, completion: @escaping (UIImage?, Int) -> Void) {
        let asset = assetForItem(number: number)
        cache.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
            completion(image, number)
        }
    }
}

extension UserPhotosListProvider {
    private func requestPhotosAccess() async throws {
        let authorization = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch authorization {
        case .limited, .authorized:
            if let accessError = PHPhotoLibrary.shared().unavailabilityReason {
                throw accessError
            }
        default:
            throw UserPhotosThumbnailsProviderError.invalidPhotosAuthorization
        }
    }
}