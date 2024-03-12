//
//  UIView+Constraints.swift
//  EditorBase
//
//  Created by Luong Manh on 15/05/2023.
//

import UIKit
import Stevia

@resultBuilder public struct LayoutBuilder {
    public static func buildBlock(_ content: Any?...) -> [Any?] {
        return content
    }
}

public extension UIView {
    @discardableResult
    func tryLayout(@LayoutBuilder content: () -> [Any?]) -> UIView {
        let subviews = content().compactMap({ $0 as? SteviaLayoutItem })
        let anys = subviews.map { $0.any }
        layout(anys)
        return self
    }
}

public extension NSLayoutConstraint {
    static func activate(@LayoutBuilder content: () -> [Any?]) {
        let values = content()
        activate(values)
    }
    
    static func activate(_ content: [Any?]) {
        for value in content {
            if let constraint = value as? NSLayoutConstraint {
                constraint.isActive = true
            } else if let constraints = value as? [Any?] {
                activate(constraints)
            }
        }
    }
}

public extension UIView {
    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        self.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        self.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult
    func height(
        _ anchor: NSLayoutDimension,
        constant: CGFloat = 0,
        multiplier: CGFloat = 1
    ) -> Self {
        self.heightAnchor
            .constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            .isActive = true
        return self
    }
    
    @discardableResult
    func width(
        _ anchor: NSLayoutDimension,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0
    ) -> Self {
        self.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            .isActive = true
        return self
    }
}

public extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
    
    func with(priority: Float) -> NSLayoutConstraint {
        self.priority = .init(priority)
        return self
    }
}

extension UIView {
    public func constraints(
        insideOrEqualSafeAreaOf otherView: UIView,
        edges: UIRectEdge,
        constant: CGFloat) -> [NSLayoutConstraint] {
            var constraints: [NSLayoutConstraint] = []
            if edges.contains(.top) {
                constraints += [
                    self.topAnchor.constraint(
                        greaterThanOrEqualTo: otherView.topAnchor, constant: constant),
                    self.topAnchor.constraint(
                        greaterThanOrEqualTo: otherView.safeAreaLayoutGuide.topAnchor),
                    self.topAnchor.constraint(
                        equalTo: otherView.safeAreaLayoutGuide.topAnchor)
                    .with(priority: .defaultLow)
                ]
            }
            if edges.contains(.bottom) {
                constraints += [
                    self.bottomAnchor.constraint(
                        lessThanOrEqualTo: otherView.bottomAnchor, constant: -constant),
                    
                    self.bottomAnchor.constraint(
                        lessThanOrEqualTo: otherView.safeAreaLayoutGuide.bottomAnchor),
                    
                    self.bottomAnchor.constraint(
                        equalTo: otherView.safeAreaLayoutGuide.bottomAnchor)
                    .with(priority: .defaultLow)
                ]
            }
            if edges.contains(.left) {
                constraints += [
                    self.leadingAnchor.constraint(
                        greaterThanOrEqualTo: otherView.leadingAnchor, constant: constant),
                    
                    self.leadingAnchor.constraint(
                        greaterThanOrEqualTo: otherView.safeAreaLayoutGuide.leadingAnchor),
                    
                    self.leadingAnchor.constraint(
                        equalTo: otherView.safeAreaLayoutGuide.leadingAnchor)
                    .with(priority: .defaultLow)
                ]
            }
            if edges.contains(.right) {
                constraints += [
                    self.trailingAnchor.constraint(
                        lessThanOrEqualTo: otherView.trailingAnchor, constant: -constant),
                    
                    self.trailingAnchor.constraint(
                        lessThanOrEqualTo: otherView.safeAreaLayoutGuide.trailingAnchor),
                    
                    self.trailingAnchor.constraint(
                        equalTo: otherView.safeAreaLayoutGuide.trailingAnchor)
                    .with(priority: .defaultLow)
                ]
            }
            
            return constraints
        }

    func bottomConstraint() -> NSLayoutConstraint? {
        var targetConstraint: NSLayoutConstraint?
        self.constraints.forEach { (constraint) in
            if (constraint.firstItem as? UIView) == self &&
                constraint.firstAttribute == NSLayoutConstraint.Attribute.bottom {
                targetConstraint = constraint
            }
        }

        return targetConstraint
    }
}
