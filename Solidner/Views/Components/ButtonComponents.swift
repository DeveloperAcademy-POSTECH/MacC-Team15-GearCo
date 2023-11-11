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
    
    var body: some View {
        tinyButton(title: "몰루",disabledCondition: false, action: {})
    }
    
    func bigButton(title: String, disabledCondition: Bool, action: @escaping ()->Void ) -> some View {
        return Button(action: action){
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(.blue)
                .frame(height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(.white)
                }
        }
    }
    
    func smallButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(.blue)
                .frame(width: smallButtonWidth, height: buttonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(.white)
                }
        }
    }
    
    func tinyButton(title: String, disabledCondition: Bool, action: @escaping () -> Void ) -> some View {
        return Button(action: action) {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(.blue)
                .frame(width: tinyButtonWidth, height: tinyButtonHeight)
                .overlay {
                    Text(title)
                        .foregroundColor(.white)
                }
        }
    }
    
}

struct ButtonComponents_Previews: PreviewProvider {
    static var previews: some View {
        ButtonComponents()
    }
}
