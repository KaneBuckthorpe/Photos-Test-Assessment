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
    case phAssetNotFound
}

class UserPhotosListProvider: PhotosGridImagesProvider {
    let cache: PHCachingImageManager
    
    private lazy var allPhotos: PHFetchResultCollection = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeHiddenAssets = false
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1000
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        return PHFetchResultCollection(fetchResult: allPhotos)
    }()
    
    private var photoIdentifiers: [String] { allPhotos.map(\.localIdentifier).reversed() }
    
    init(cache: PHCachingImageManager) {
        self.cache = cache
    }
    
    func fetchPhotoIdentifiers() async throws -> [String] {
        try await requestPhotosAccess()
        return photoIdentifiers
    }

    func imageForItem(_ identifier: String, targetSize: CGSize) async throws -> (UIImage?) {
        guard let asset = allPhotos.first(where: { $0.localIdentifier == identifier }) else {
            throw UserPhotosThumbnailsProviderError.phAssetNotFound
        }
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            self?.cache.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: options,
                resultHandler: { image, info in
                    if let error = info?[PHImageErrorKey] as? Error {
                        continuation.resume(throwing: error)
                        return
                    }
                    continuation.resume(returning: image)
                }
            )
        }
    }
}

extension UserPhotosListProvider {
    private func requestPhotosAccess() async throws {
        let authorization = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch authorization {
        case .authorized:
            if let accessError = PHPhotoLibrary.shared().unavailabilityReason {
                throw accessError
            }
        default:
            throw UserPhotosThumbnailsProviderError.invalidPhotosAuthorization
        }
    }
}
