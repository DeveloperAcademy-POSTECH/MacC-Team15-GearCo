//
//  UINavigationController+.swift
//  Solidner
//
//  Created by sei on 12/2/23.
//

// thansk to - https://stackoverflow.com/questions/59921239/hide-navigation-bar-without-losing-swipe-back-gesture-in-swiftui
// swipe back gesture

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
