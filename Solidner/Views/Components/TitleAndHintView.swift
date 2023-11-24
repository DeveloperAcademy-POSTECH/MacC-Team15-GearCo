//
//  TitleAndHintView.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct TitleAndHintView: View {
    let title: String
    let hint: String
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let textAlignment: TextAlignment
    private(set) var type: TitleAndHintType? = nil
    @State private(set) var titleColor: Color
    @State private(set) var hintColor: Color

    func set(titleColor: Color, hintColor: Color) -> Self {
        var _view = self
        _view._titleColor = State(initialValue: titleColor)
        _view._hintColor = State(initialValue: hintColor)
        return _view
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
        .multilineTextAlignment(textAlignment)
    }
}

extension TitleAndHintView {
    init(
        title: String,
        titleColor: Color = .defaultText,
        hint: String,
        hintColor: Color = .primeText.opacity(0.6),
        spacing: CGFloat = 16,
        alignment: HorizontalAlignment = .leading,
        textAlignment: TextAlignment = .leading
    ) {
        self.title = title
        self._titleColor = State(initialValue: titleColor)
        self.hint = hint
        self._hintColor = State(initialValue: hintColor)
        self.spacing = spacing
        self.alignment = alignment
        self.textAlignment = textAlignment
    }

    init(type: TitleAndHintType, title:String, hint: String) {
        switch type {
        case .center12:
            self.spacing = 12
            self.alignment = .center
            self.textAlignment = .center
        case .leading14:
            self.spacing = 14
            self.alignment = .leading
            self.textAlignment = .leading
        }
        self.title = title
        self.hint = hint
        self._titleColor = State(initialValue: .defaultText.opacity(0.8))
        self._hintColor = State(initialValue: .primary.opacity(0.6))
    }
}

extension TitleAndHintView {
    enum TitleAndHintType {
        case center12, leading14
    }
}
