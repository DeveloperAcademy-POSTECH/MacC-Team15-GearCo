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
   
    var body: some View {
        smallButton(disabledCondition: false, action: {})
    }
    
    func bitButtonLabel(disabledCondition: Bool, title: String = "다음", buttonColor: Color = Color.buttonDefaultColor, titleColor: Color = Color.buttonDefaultTextColor) -> some View {
        RoundedRectangle(cornerRadius: buttonCornerRadius)
            .fill(disabledCondition ? Color.buttonDisabledColor : buttonColor)
            .frame(height: buttonHeight)
            .overlay {
                Text(title)
                    .foregroundColor(disabledCondition ? Color.buttonDisabledTextColor : titleColor)
            }
    }
    
    func bigButton(title: String = "다음" , disabledCondition: Bool, action: @escaping ()->Void, buttonColor: Color = Color.buttonDefaultColor, titleColor: Color = Color.buttonDefaultTextColor) -> some View {
        return Button(action: action){
            bitButtonLabel(disabledCondition: disabledCondition, title: title, buttonColor: buttonColor, titleColor: titleColor)
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
        ButtonComponents()
    }
}
