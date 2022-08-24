//
//  NSLayoutAnchor+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

extension NSLayoutAnchor {
    /// Returns an active constraint that defines one item’s attribute as equal to another item’s attribute plus a constant offset.
    /// - Parameters:
    ///   - anchor: Anchor to constrain to.
    ///   - constant: Value to add to constraint.
    /// - Returns: An active NSLayoutConstraint object that defines an equal relationship between the
    /// attributes represented by the two layout anchors plus a constant offset.
    @discardableResult
    @objc
    public func constrainTo(_ anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
}
