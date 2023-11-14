//
//  TextFieldComponents.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct TextFieldComponents: View {
    let placeHolder = "최대 10자내로  입력이 가능해요."
    let textFieldColor = Color(#colorLiteral(red: 0.9277959466, green: 0.9277958274, blue: 0.9277958274, alpha: 1))
    let placeHolderColor = Color(#colorLiteral(red: 0.6429678202, green: 0.6429678202, blue: 0.6429678202, alpha: 1))
    let textFieldCornerRadius: CGFloat = 12
    let textFieldPadding: CGFloat = 16
    @State private var value = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        shortTextfield(placeHolder: placeHolder, value: $value, isFocused: $isFocused)
    }
    
    func shortTextfield(placeHolder: String, value: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        TextField("", text: value, prompt: Text(placeHolder).foregroundColor(placeHolderColor))
            .focused(isFocused)
            .padding(textFieldPadding)
            .background(textFieldColor)
            .cornerRadius(textFieldCornerRadius)
    }
}

struct TextFieldComponents_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldComponents()
    }
}
