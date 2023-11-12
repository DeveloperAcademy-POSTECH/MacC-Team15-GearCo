//
//  ButtonComponents.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/09.
//

import SwiftUI

struct ButtonComponents: View {
    let buttonHeight: CGFloat = 56
    let smallButtonWidth: CGFloat = 138
    let buttonCornerRadius: CGFloat = 12
    let tinyButtonHeight: CGFloat = 48
    let tinyButtonWidth: CGFloat = 96
    let buttonDisabledColor = Color(#colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1))
    let buttonDisabledTextColor = Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1))
    
    var body: some View {
        tinyButton(title: "몰루",disabledCondition: false, action: {})
    }
    
    func bigButton(title: String, disabledCondition: Bool, action: @escaping ()->Void ) -> some View {
        return Button(action: action){
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? buttonDisabledColor : .blue)
                .frame(height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? buttonDisabledTextColor : .white)
                }
        }
        .disabled(disabledCondition)
    }
    
    func smallButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? buttonDisabledColor : .blue)
                .frame(width: smallButtonWidth, height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? buttonDisabledTextColor : .white)
                }
        }
        .disabled(disabledCondition)
    }
    
    func tinyButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(disabledCondition ? buttonDisabledColor : .blue)
                .frame(width: tinyButtonWidth, height: tinyButtonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(disabledCondition ? buttonDisabledTextColor : .white)
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
