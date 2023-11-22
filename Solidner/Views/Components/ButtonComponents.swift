//
//  ButtonComponents.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/09.
//

import SwiftUI

struct ButtonComponents: View {
    private let buttonHeight: CGFloat = 56
    private let smallButtonWidth: CGFloat = 138
    private let buttonCornerRadius: CGFloat = 12
    private let tinyButtonHeight: CGFloat = 48
    private let tinyButtonWidth: CGFloat = 96
    let buttonType: ButtonType
    let title: String
    let disabledCondition: Bool
    let action: () -> Void

    @State private var isClicked = false
    @State private var titleColor: Color?
    func titleColor(_ color: Color) -> Self {
        var view = self
        view._titleColor = State(initialValue: color)
        return view
    }

    @State private var buttonColor: Color?
    func buttonColor(_ color: Color) -> Self {
        var view = self
        view._buttonColor = State(initialValue:color)
        return view
    }

    enum ButtonType {
        case big, small, tiny, clickableTiny
    }

    init(_ buttonType: ButtonType = .small, title: String = "다음", disabledCondition: Bool = false, action: @escaping () -> Void = {}) {
        self.buttonType = buttonType
        self.title = title
        self.disabledCondition = disabledCondition
        self.action = action
    }

    var body: some View {
        switch buttonType {
        case .big:
            bigButton(
                title: title,
                disabledCondition: disabledCondition,
                action: action,
                buttonColor: buttonColor ?? Color.accentColor1,
                titleColor: titleColor ?? Color.defaultText_wh
            )
        case .small:
            smallButton(
                title: title,
                disabledCondition: disabledCondition,
                action: action
            )
        case .tiny:
            tinyButton(
                title: title,
                disabledCondition: disabledCondition,
                action: action
            )
        case .clickableTiny:
            clickableTinyButton(disabledCondition: disabledCondition, action: action)
        }
    }

    func bigButton(title: String = "다음" , disabledCondition: Bool, action: @escaping () -> Void, buttonColor: Color, titleColor: Color) -> some View {
        return Button(action: action){
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? buttonColor.opacity(0.2) : buttonColor)
                .frame(height: buttonHeight)
                .overlay {
                    Text(title)
                        .buttonFont()
                        .foregroundColor(titleColor)
                }
        }
        .disabled(disabledCondition)
    }

    func smallButton(title: String = "다음", disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? Color.accentColor1.opacity(0.2) : Color.accentColor1)
                .frame(width: smallButtonWidth, height: buttonHeight)
                .overlay {
                    Text(title)
                        .buttonFont()
                        .foregroundColor(.defaultText_wh)
                }
        }
        .disabled(disabledCondition)
    }

    func tinyButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(Color.buttonBgColor)
                .frame(width: tinyButtonWidth, height: tinyButtonHeight)
                .overlay {
                    Text(title)
                        .headerFont6()
                        .foregroundColor(.primeText)
                }
        }
        .disabled(disabledCondition)
    }
    
    func clickableTinyButton(disabledCondition: Bool, action: @escaping () -> Void) -> some View {
        return Button(action: {
            action()
            isClicked.toggle()
        }) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(isClicked ? Color.accentColor1 : Color.buttonBgColor, strokeBorder: Color.buttonStrokeColor, lineWidth: 1.5)
                .frame(width: tinyButtonWidth, height: tinyButtonHeight)
                .overlay {
                    Text(isClicked ? "추가됨" : "재료 추가")
                        .headerFont6()
                        .foregroundColor(isClicked ? .defaultText_wh : .primeText)
                }
        }
        .disabled(disabledCondition)
    }
}

struct ButtonComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonComponents(.big,
                             title: "이전",
                             disabledCondition: false
            ) {
                print(#function)
            }
            .buttonColor(.red)
            .titleColor(.black)
            ButtonComponents(.small,
                             title: "다음",
                             disabledCondition: false
            ) {
                print(#function)
            }
            ButtonComponents(.tiny,
                             title: "이전",
                             disabledCondition: true
            ) {
                print(#function)
            }
            ButtonComponents(.clickableTiny)
        }
    }
}
