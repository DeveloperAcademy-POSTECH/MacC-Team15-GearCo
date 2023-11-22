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
        case big, small, tiny
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
                titleColor: titleColor ?? Color.buttonDefaultTextColor
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
        }
    }

    func bigButton(title: String = "다음" , disabledCondition: Bool, action: @escaping () -> Void, buttonColor: Color = .buttonDefaultColor, titleColor: Color = .buttonDefaultTextColor) -> some View {
        return Button(action: action){
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? Color.buttonDisabledColor : buttonColor)
                .frame(height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? Color.buttonDisabledTextColor : titleColor)
                }
        }
        .disabled(disabledCondition)
    }

    func smallButton(title: String = "다음", disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? Color.buttonDisabledColor : Color.buttonDefaultColor)
                .frame(width: smallButtonWidth, height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? Color.buttonDisabledTextColor : Color.buttonDefaultTextColor)
                }
        }
        .disabled(disabledCondition)
    }

    func tinyButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? Color.buttonDisabledColor : Color.buttonDefaultColor)
                .frame(width: tinyButtonWidth, height: tinyButtonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? Color.buttonDisabledTextColor : Color.buttonDefaultTextColor)
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
                             title: "이전",
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
        }
    }
}
