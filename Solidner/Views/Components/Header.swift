//
//  Header.swift
//  Solidner
//
//  Created by sei on 11/26/23.
//

import SwiftUI

fileprivate enum K {
    static var backButtonPadding: CGFloat { 16 }
}

struct RightButtonOnlyHeader<Right: View>: View {
    private(set) var rightButton: Right
    
    var body: some View {
        Header(.rightButtonOnly, rightButton: rightButton)
            .padding(top: .zero, leading: .zero, bottom: .zero, trailing: 26)
    }
}

struct LeftRightButtonHeader<Left: View, Right: View>: View {
    private(set) var leftButton: Left
    private(set) var rightButton: Right
    
    var body: some View {
        Header(.leftRightButton, leftButton: leftButton, rightButton: rightButton
        )
            .padding(top: .zero, leading: 20, bottom: .zero, trailing: 18)
    }
}

struct BackButtonOnlyHeader: View {
    var body: some View {
        Header(.backButtonOnly)
            .padding(top: .zero, leading: K.backButtonPadding, bottom: .zero, trailing: .zero)
    }
}

struct BackButtonAndRightHeader<Right: View>: View {
    let rightButton: Right
    
    var body: some View {
        Header(.backButtonAndRight, rightButton: rightButton)
            .padding(top: .zero, leading: K.backButtonPadding, bottom: .zero, trailing: 26)
    }
}

struct BackButtonAndTitleHeader: View {
    let title: String
    
    var body: some View {
        Header(.backButtonAndTitle, title: title)
            .padding(top: .zero, leading: K.backButtonPadding/2, bottom: .zero, trailing: K.backButtonPadding/2)
    }
}

fileprivate struct Header<Left: View, Right: View>: View {
    enum HeaderType {
        case backButtonOnly
        case rightButtonOnly
        case backButtonAndRight
        case backButtonAndTitle
        case leftRightButton
    }
    
    @Environment(\.dismiss) private var dismiss
    
    let type: HeaderType
    
    let leftButton: Left
    let title: String
    let rightButton: Right
    
    init(_ type: HeaderType,
        title: String = "",
         leftButton: Left = EmptyView(),
         rightButton: Right = EmptyView()) {
        self.type = type
        self.title = title
        self.leftButton = leftButton
        self.rightButton = rightButton
    }
    
    var body: some View {
        HStack {
            left
            Spacer()
            rightButton
        }
        .overlay {
            titleTextView
        }
        .frame(height: K.defaultHeight)
    }
    
    @ViewBuilder
    private var left: some View {
        switch type {
        case .backButtonOnly, .backButtonAndRight, .backButtonAndTitle:
            backButton
        case .leftRightButton:
            leftButton
        case .rightButtonOnly:
            EmptyView()
        }
    }
    
    private var backButton: some View  {
        Button {
            dismiss()
        } label: {
            Image(assetName: .headerChevron)
        }
    }
    
    @ViewBuilder
    private var titleTextView: some View  {
        if type == .backButtonAndTitle {
            Text(title)
                .customFont(.header5, color: .defaultText)
        }
    }
}

extension Header {
    private enum K {
        static var defaultHeight: CGFloat { 54 }
    }
}

#Preview {
    let action = { print(#function )}
    let leftButton = Button {
        action()
    }  label: { Text("왼쪽") }
    let rightButton = Button {
        action()
    }  label: { Text("오른쪽") }
    return Group {
        BackButtonOnlyHeader()
        BackButtonAndTitleHeader(title: "재료 입력")
        LeftRightButtonHeader(leftButton: leftButton, rightButton: rightButton)
        BackButtonAndRightHeader(rightButton: rightButton)
    }
}
