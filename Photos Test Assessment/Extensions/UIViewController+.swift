//
//  UIViewController+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

extension UIViewController {
    public func embed(
        _ viewController: UIViewController,
        into parentView: UIView,
        by constraints: [SubviewConstraint] = .edges()
    ) {
        addChild(viewController)
        parentView.addConstrainedSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    public func embed(
        _ viewController: UIViewController,
        by constraints: [SubviewConstraint] = .edges()
    ) {
        addChild(viewController)
        view.addConstrainedSubview(viewController.view)
        viewController.didMove(toParent: self)
    }

    public func removeChild(_ child: UIViewController?) {
        guard let child = child else { return }
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
