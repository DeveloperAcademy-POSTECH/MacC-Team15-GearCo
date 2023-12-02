//
//  ThickDivider.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct ThickDivider: View {

    @State private var foregroundColor: Color = K.foregroundColor

    func foregroundColor(_ color: Color) -> ThickDivider {
        var view = self
        view._foregroundColor = State(initialValue:color)
        return view
    }

    private enum K {
        static var foregroundColor: Color { .dividerColor.opacity(0.2) }
        static var height: CGFloat { 10 }
        static var horizontalPadding: CGFloat { -20 }
    }


    var body: some View {
        Rectangle()
            .foregroundStyle(foregroundColor)
            .frame(height: K.height)
            .padding(.horizontal, K.horizontalPadding)
    }
}
