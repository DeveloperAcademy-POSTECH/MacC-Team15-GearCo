//
//  View+.swift
//  Solidner
//
//  Created by 이재원 on 11/21/23.
//

import SwiftUI

extension View {
    func withClearBackground(color: Color) -> some View {
        self.background(color)
            .scrollContentBackground(.hidden)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self), !(view is EmptyView) {
            view
        } else {
            self
        }
    }
}

extension View {
    /// Symmetric하게 padding을 넣고 싶을 때 사용
    /// - Parameters:
    ///   - horizontal: horizontal Padding값
    ///   - vertical: vertical Padding값
    /// - Returns: Symmetrically Padded View
    func padding(horizontal: CGFloat, vertical: CGFloat) -> some View {
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
        top: Double,
        leading: Double,
        bottom: Double,
        trailing: Double
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
    /// Horizontal 동일, Top과 Bottom Padding은 다르게
    /// - Parameters:
    ///   - top: top Padding
    ///   - leading: leading Padding
    ///   - bottom: bottom Padding
    ///   - trailing: trailing Padding
    /// - Returns: Padded View
    func padding(
        horizontal: Double,
        top: Double,
        bottom: Double
    ) -> some View {
        return self.padding(
            EdgeInsets(
                top: top,
                leading: horizontal,
                bottom: bottom,
                trailing: horizontal
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
