//
//  WarningView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct WarningView: View {
    private let texts = TextLiterals.Warning.self
    private enum K {
        static var warningIconSystemName: String { "exclamationmark.triangle.fill" }
        static var verticalPadding: CGFloat { 25 }
        static var cornerRadius: CGFloat { 12 }
    }

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: K.warningIconSystemName)
                .foregroundStyle(Color.accentColor)
            Text(texts.warningText)
        }
        .padding(.vertical, K.verticalPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: K.cornerRadius)
                .foregroundStyle(Color.gray)
        )
    }
}

#Preview {
    WarningView()
}
