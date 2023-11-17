//
//  UIScreen+.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/17.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

    static func getWidth(_ width: CGFloat) -> CGFloat {
        screenWidth / 390 * width
    }
    
    static func getHeight(_ height: CGFloat) -> CGFloat {
        screenHeight / 844 * height
    }
}
