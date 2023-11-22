//
//  View+.swift
//  Solidner
//
//  Created by sei on 11/21/23.
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
