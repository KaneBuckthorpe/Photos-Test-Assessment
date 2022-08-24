//
//  PhotosFlow.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

class PhotosFlow {
    
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [photosGrid]
        return navigationController
    }()
    
    lazy var photosGrid: UIViewController = {
        let imageProvider = UserPhotosListProvider()
        let viewController = PhotosGridViewController(imageProvider: imageProvider)

        viewController.photoTapHandler = { [unowned viewController, unowned imageProvider] number in
            let asset = imageProvider.assetForItem(number: number)
            let singleImageProvider = UserPhotoProvider(cache: imageProvider.cache, asset: asset)
            let photoViewerViewController = PhotoViewerViewController(imageProvider: singleImageProvider, saliencyService: VisionAttentionSaliencyImageService())
            viewController.show(photoViewerViewController, sender: self)
        }
        
        viewController.errorHandler = { [unowned viewController] _ in
            let alert = UIAlertController(
                title: "Unable to fetch images",
                message: "Check image access and try again",
                preferredStyle: .alert
            )
            
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            
            viewController.present(alert, animated: true)
        }
        
        viewController.title = "Recents"
        return viewController
    }()
}

extension UIImage {
    static func systemName(_ systemName: String, color: UIColor) -> UIImage? {
        UIImage(systemName: systemName)?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(color)
            .withRenderingMode(.alwaysOriginal)
    }
    static func backButton(color: UIColor) -> UIImage? {
        UIImage.systemName("arrow.backward", color: color)
    }
    
    static func scaleToggle(color: UIColor) -> UIImage? {
        UIImage.systemName("arrow.up.left.and.down.right.magnifyingglass", color: color)
    }
}

extension UINavigationBarAppearance {
    static var whitebackButton: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        let image = UIImage.backButton(color: .white)
        appearance.setBackIndicatorImage(image, transitionMaskImage: image)
        return appearance
    }
}
