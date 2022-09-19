//
//  PhotosRouter.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

protocol PhotosViewControllerFactoryProtocol {
    typealias PhotoTapCallback = (String) -> Void
    typealias PhotosErrorCallback = (Error, UIViewController) -> Void
    func photosGridViewContoller(photoTapCallback: @escaping PhotoTapCallback, errorCallback: @escaping PhotosErrorCallback) -> UIViewController
    func photoViewerViewController(for imageId: String) -> UIViewController
    func photoFetchErrorAlertController(_ error: Error) -> UIViewController
}

class PhotosRouter {
    
    let navigationController: UINavigationController
    let factory: PhotosViewControllerFactoryProtocol
    
    init(navigationController: UINavigationController, factory: PhotosViewControllerFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewController = factory.photosGridViewContoller(photoTapCallback: { [unowned self] imageId in
            self.showPhotoViewer(imageId: imageId)
        }, errorCallback: { [unowned self] error, presenter in
            self.showImageFetchError(error, presenter: presenter)
        })
        navigationController.viewControllers = [viewController]
    }
    
    private func showPhotoViewer(imageId: String) {
        let viewController = factory.photoViewerViewController(for: imageId)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showImageFetchError(_ error: Error, presenter: UIViewController) {
        let alert = factory.photoFetchErrorAlertController(error)
        presenter.present(alert, animated: true)
    }
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
