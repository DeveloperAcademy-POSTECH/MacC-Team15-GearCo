//
//  View+.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

extension View {
    /// Symmetric하게 padding을 넣고 싶을 때 사용
    /// - Parameters:
    ///   - horizontal: horizontal Padding값
    ///   - vertical: vertical Padding값
    /// - Returns: Symmetrically Padded View
    func padding(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> some View {
        self.padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
    }
    
    /// Left, Top, Right, Bottom Padding
    /// - Parameters:
    ///   - top: top Padding
    ///   - leading: leading Padding
    ///   - bottom: bottom Padding
    ///   - trailing: trailing Padding
    /// - Returns: Padded View
    func padding(
        top: Double = 0,
        leading: Double = 0,
        bottom: Double = 0,
        trailing: Double = 0
    ) -> some View {
        return self.padding(
            EdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
    
    /// 글자에 가로세로 대칭 padding과 배경색을 주고 싶을 때 사용
    /// - Parameters:
    ///   - HPad: Horizontal Padding
    ///   - VPad: Vertical Padding
    ///   - color: Background Color
    ///   - radius: Background CornerRadius
    /// - Returns: Backgrounded View
    func symmetricBackground(HPad: CGFloat = 0,
                             VPad: CGFloat = 0,
                             color: Color = .clear,
                             radius: CGFloat = 0)
    -> some View {
        self.padding(horizontal: HPad, vertical: VPad)
            .background {
                RoundedRectangle(cornerRadius: radius)
                    .fill(color)
            }
    }
}
