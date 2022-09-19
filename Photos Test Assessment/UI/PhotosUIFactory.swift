//
//  PhotosUIFactory.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 19/09/2022.
//

import UIKit
import class Photos.PHCachingImageManager

class PhotosUIFactory: PhotosViewControllerFactoryProtocol {

    let imageCache = PHCachingImageManager()

    func photosGridViewContoller(photoTapCallback: @escaping PhotoTapCallback, errorCallback: @escaping (Error, UIViewController) -> Void) -> UIViewController {
        let imageProvider = UserPhotosListProvider(cache: imageCache)
        let viewController = PhotosGridViewController(imageProvider: imageProvider)
        
        viewController.errorHandler = { [unowned viewController] error in
            errorCallback(error, viewController)
        }
        viewController.photoTapHandler = photoTapCallback
        viewController.title = "Recents"
        return viewController
    }
    
    func photoViewerViewController(for imageId: String) -> UIViewController {
        let imageProvider = UserPhotoProvider(cache: imageCache, localIdentifier: imageId)
        let saliencyService = VisionAttentionSaliencyImageService()
        let viewController = PhotoViewerViewController(imageProvider: imageProvider, saliencyService: saliencyService)
        
        return viewController
    }
    
    func photoFetchErrorAlertController(_ error: Error) -> UIViewController {
        let alert = UIAlertController(
            title: "Unable to fetch images",
            message: "Check image access and try again",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        return alert
    }
}
