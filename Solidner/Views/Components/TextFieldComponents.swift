//
//  TextFieldComponents.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct TextFieldComponents: View {
    let textFieldCornerRadius: CGFloat = 12
    let textFieldPadding: CGFloat = 16
    @State private var value = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        shortTextfield(placeHolder: TextLiterals.ViewComponents.placeHolderMessage, value: $value, isFocused: $isFocused)
    }
    
    func shortTextfield(placeHolder: String, value: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        TextField("", text: value, prompt: Text(placeHolder).foregroundColor(Color.placeHolderColor))
            .focused(isFocused)
            .padding(textFieldPadding)
            .background(Color.textFieldColor)
            .cornerRadius(textFieldCornerRadius)
    }
}

struct TextFieldComponents_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldComponents()
    }
}
