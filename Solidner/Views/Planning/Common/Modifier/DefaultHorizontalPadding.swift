//
//  DefaultHorizontalPadding.swift
//  Solidner
//
//  Created by sei on 11/26/23.
//

import Foundation
import SwiftUI

struct DefaultHorizontalPadding: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.horizontal, ViewCommonConstants.horizontalPadding)
    }
}

extension View {
    func defaultHorizontalPadding() -> some View {
        self.modifier(DefaultHorizontalPadding())
    }
}
