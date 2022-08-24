//
//  NSLayoutDimension+.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

extension NSLayoutDimension {
    /// Returns an active constraint that defines the anchor’s size attribute as equal
    /// to the specified size attribute multiplied by a constant plus an offset.
    /// - Parameters:
    ///   - dimension: Dimension to constrain to
    ///   - multiplier: Value to multiply constraint by
    ///   - constant: Value to add to constraint
    /// - Returns: An active NSLayoutConstraint object that defines the attribute represented by this layout anchor
    /// as equal to the attribute represented by the anchor parameter multiplied by the m constant plus the constant c.
    @discardableResult
    public func constrainTo(
        _ dimension: NSLayoutDimension,
        multiplier: CGFloat = 0,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: dimension, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// Returns an active constraint that defines a constant size for the anchor’s size attribute.
    /// - Parameter constant: Value to constrain by
    /// - Returns: An active NSLayoutConstraint object that defines a constant size for the attribute associated with this dimension anchor.
    @discardableResult
    public func constrainTo(constant: CGFloat) -> NSLayoutConstraint {
        let constraint = constraint(equalToConstant: constant)
        constraint.isActive = true
        return constraint
    }
}
