//
//  UIView+Layout.swift
//  Photos Test Assessment
//
//  Created by kane buckthorpe on 21/08/2022.
//

import UIKit

public enum SubviewConstraint {
    case leading(_ padding: CGFloat = 0)
    case top(_ padding: CGFloat = 0)
    case trailing(_ padding: CGFloat = 0)
    case bottom(_ padding: CGFloat = 0)
    case safeLeading(_ padding: CGFloat = 0)
    case safeTop(_ padding: CGFloat = 0)
    case safeTrailing(_ padding: CGFloat = 0)
    case safeBottom(_ padding: CGFloat = 0)
    case centerX(_ padding: CGFloat = 0)
    case centerY(_ padding: CGFloat = 0)
    case safeCenterX(_ padding: CGFloat = 0)
    case safeCenterY(_ padding: CGFloat = 0)
    
    public static let center: [Self] = [.centerX(), .centerY()]
}

extension Collection where Element == SubviewConstraint {
    public static var center: [Element] { [.centerX(), .centerY()] }

    public static func edges(_ padding: CGFloat = 0) -> [Element] {
        vertical(padding) + horizontal(padding)
    }
    
    public static func vertical(_ padding: CGFloat = 0) -> [Element] {
        [.top(padding), .bottom(padding)]
    }

    public static func horizontal(_ padding: CGFloat = 0) -> [Element] {
        [.leading(padding), .trailing(padding)]
    }
}

extension Collection where Element == SubviewConstraint {
    public static func safeEdges(_ padding: CGFloat = 0) -> [Element] {
        safeVertical(padding) + safeHorizontal(padding)
    }

    public static func safeVertical(_ padding: CGFloat = 0) -> [Element] {
        [.safeTop(padding), .safeBottom(padding)]
    }

    public static func safeHorizontal(_ padding: CGFloat = 0) -> [Element] {
        [.safeLeading(padding), .safeTrailing(padding)]
    }
}

extension UIView {
    /// Adds a subview constrained by the given SubviewConstraints.
    /// - Parameters:
    ///   - subview: Child view to be added
    ///   - constraints: Constraints to attach the subview by. Default pins to edges.
    ///   - zIndex: The index in the array of the subviews property at which to insert the view.
    ///   Subview indices start at 0 and cannot be greater than the number of subviews.
    public func addConstrainedSubview(
        _ subview: UIView,
        by constraints: [SubviewConstraint] = .edges(),
        at zIndex: Int? = nil) {
            
            subview.translatesAutoresizingMaskIntoConstraints = false
            if let zIndex = zIndex {
                insertSubview(subview, at: zIndex)
            } else {
                addSubview(subview)
            }
            addConstraints(constraints, to: subview)
    }
    
    /// Adds constraints between two views
    /// - Parameters:
    ///   - constraints: Constraints to attach the views by
    ///   - view: Second view to add constraints to
    public func addConstraints(_ constraints: [SubviewConstraint], to view: UIView) {
        let layoutConstraints = constraints.map { constraint($0, to: view) }
        NSLayoutConstraint.activate(layoutConstraints)
    }

    ///  Returns a constraint that defines one view's attribute as equal to another view's attribute.
    /// - Parameters:
    ///   - constraint: Constraint to be added
    ///   - view: Second view to add constraints to
    /// - Returns: An NSLayoutConstraint object that defines an equal relationship between the attributes represented by the SubviewConstraint.
    private func constraint(_ constraint: SubviewConstraint, to view: UIView) -> NSLayoutConstraint {

        switch constraint {
        case .leading(let padding):
            return  view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
        case .top(let padding):
            return view.topAnchor.constraint(equalTo: topAnchor, constant: padding)
        case .trailing(let padding):
            return trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        case .bottom(let padding):
            return bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        case .safeLeading(let padding):
            return view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding)
        case .safeTop(let padding):
            return view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding)
        case .safeTrailing(let padding):
            return safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: padding)
        case .safeBottom(let padding):
            return safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: padding)
        case .centerX(let padding):
            return view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: padding)
        case .centerY(let padding):
            return view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: padding)
        case .safeCenterX(let padding):
            return view.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: padding)
        case .safeCenterY(let padding):
            return view.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: padding)
        }
    }
    
    /// Returns a constraint that defines a width to height aspectRatio constraint plus the additional constant.
    /// - Parameters:
    ///   - ratio: Ratio to constrain by
    ///   - constant: Value to add to constraint
    /// - Returns: An NSLayoutConstraint object that represents a width to height relationship, defined by the given ratio.
    public func aspectRatioConstraint(ratio: CGFloat, constant: CGFloat = 0) -> NSLayoutConstraint {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio, constant: constant)
    }
    
    /// Returns an active constraint that defines a width to height aspectRatio constraint plus the additional constant.
    /// - Parameters:
    ///   - ratio: Ratio to constrain by
    ///   - constant: Value to add to constraint
    /// - Returns: An active NSLayoutConstraint object that represents a width to height relationship, defined by the given ratio.
    @discardableResult
    public func constrainTo(aspectRatio: CGFloat, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = aspectRatioConstraint(ratio: aspectRatio, constant: constant)
        constraint.isActive = true
        return constraint
    }
}
