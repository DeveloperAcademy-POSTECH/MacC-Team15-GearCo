//
//  DefaultHorizontalPadding.swift
//  Solidner
//
//  Created by sei on 11/26/23.
//

import Foundation
import SwiftUI

struct DefautViewBodyTopPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.top, 19.88)
    }
}

struct DefaultHorizontalPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.horizontal, 16)
    }
}

struct DefaultBottomPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.bottom, 40.responsibleHeight)
    }
}

extension View {
    func defaultHorizontalPadding() -> some View {
        self.modifier(DefaultHorizontalPadding())
    }
    
    func defaultViewBodyTopPadding() -> some View {
        self.modifier(DefautViewBodyTopPadding())
    }
    func defaultBottomPadding() -> some View {
        self.modifier(DefaultBottomPadding())
    }
}
