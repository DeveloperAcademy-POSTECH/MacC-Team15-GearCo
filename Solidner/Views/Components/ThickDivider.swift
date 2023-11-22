//
//  ThickDivider.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct ThickDivider: View {

    @State private var foregroundColor: Color = Color(uiColor: .systemGray5)

    func foregroundColor(_ color: Color) -> ThickDivider {
        var view = self
        view._foregroundColor = State(initialValue:color)
        return view
    }

    var body: some View {
        Rectangle()
            .foregroundStyle(foregroundColor)
            .frame(height: 10)
            .padding(.vertical)
            .padding(.horizontal, -100)
    }
}
