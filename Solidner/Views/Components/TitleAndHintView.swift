//
//  TitleAndHintView.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct TitleAndHintView: View {
    let title: String
    let titleColor: Color
    let hint: String
    let hintColor: Color
    let spacing: CGFloat
    let alignment: HorizontalAlignment

    init(
        title: String,
        titleColor: Color = .defaultText,
        hint: String,
        hintColor: Color = .primeText.opacity(0.6),
        spacing: CGFloat = 16,
        alignment: HorizontalAlignment = .leading
    ) {
        self.title = title
        self.titleColor = titleColor
        self.hint = hint
        self.hintColor = hintColor
        self.spacing = spacing
        self.alignment = alignment
    }

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            Text(title)
                .headerFont2()
                .foregroundStyle(titleColor)
            Text(hint)
                .bodyFont1()
                .foregroundStyle(hintColor)
        }
    }
}
