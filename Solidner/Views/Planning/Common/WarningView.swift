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
        static var vstackSpacing: CGFloat { 8 }
        static var warningIconSystemName: String { "exclamationmark.triangle.fill" }
        static var verticalPadding: CGFloat { 25 }
        static var cornerRadius: CGFloat { 12 }
        static var textColorOpacity: CGFloat { 0.5 }
        static var bottomPadding: Double { 14 }
    }

    var body: some View {
        VStack(spacing: K.vstackSpacing) {
            Image(systemName: K.warningIconSystemName)
                .foregroundStyle(Color.accentColor1)
            Text(texts.warningText)
                .headerFont5()
                .foregroundStyle(Color.defaultText)
                .opacity(K.textColorOpacity)
        }
        .padding(.vertical, K.verticalPadding)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: K.cornerRadius)
                .foregroundStyle(Color.buttonBgColor)
        )
        .padding(
            top: .zero,
            leading: .zero,
            bottom: K.bottomPadding,
            trailing: .zero
        )
    }
}

struct WarningView_Previews: PreviewProvider {
    static var previews: some View {
        WarningView()
    }
}
