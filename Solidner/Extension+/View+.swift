//
//  View+.swift
//  Solidner
//
//  Created by 이재원 on 11/21/23.
//
// code reference:
//      1. https://github.com/samuelclay/NewsBlur/blob/1f74f1a09f4777fbd9e7b48b4b42c11c58d5b8ee/clients/ios/Classes/SwiftUIUtilities.swift
// 2. https://github.com/Oztechan/CCC/blob/a16744893540b765beb18d246b72cd72f308c6b9/ios/CCC/Util/ViewExt.swift

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
    
    /// View의 왼쪽을 radius값만큼 clip하여 반환합니다. (ex.`Rectangle().leftCornerRadius(10)` 처럼 사용)
    /// - Parameter radius: radius값
    /// - Returns: 왼쪽이 둥글어진 View
    func leftCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius, corners: .topLeft)
            .cornerRadius(radius, corners: .bottomLeft)
    }
    /// View의 오른쪽을 radius값만큼 clip하여 반환합니다. (ex.`Rectangle().rightCornerRadius(10)` 처럼 사용)
    /// - Parameter radius: radius값
    /// - Returns: 오른쪽이 둥글어진 View
    func rightCornerRadius(_ radius: CGFloat) -> some View {
        self.cornerRadius(radius, corners: .topRight)
            .cornerRadius(radius, corners: .bottomRight)
    }
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
