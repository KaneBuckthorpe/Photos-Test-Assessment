//
//  SceneDelegate.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 20/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    lazy var appFlow = PhotosFlow()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard
            let windowScene = (scene as? UIWindowScene),
            window == nil
        else { return }
        
        setupWindow(windowScene)
    }
}

extension SceneDelegate {
    private func setupWindow(_ windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = appFlow.navigationController
        window?.makeKeyAndVisible()
    }
}
