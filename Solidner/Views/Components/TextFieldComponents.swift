//
//  TextFieldComponents.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct TextFieldComponents: View {
    private let textFieldCornerRadius: CGFloat = 12
    private let textFieldVerticalPadding: CGFloat = 19
    private let textFieldHorizontalPadding: CGFloat = 16
    @State var value = ""
    @FocusState var isFocused: Bool
    
    var body: some View {
        shortTextfield(placeHolder: TextLiterals.ViewComponents.placeHolderMessage, value: $value, isFocused: $isFocused)
    }
    
    func shortTextfield(placeHolder: String, value: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        TextField("", text: value, prompt: Text(placeHolder).foregroundColor(Color.placeHolderColor))
            .font(.custom(Text.FontWeightCase.medium.rawValue, size: 15))
            .foregroundColor(.defaultText)
            .focused(isFocused)
            .tint(Color.accentColor1)
            .padding(horizontal: textFieldHorizontalPadding, vertical: textFieldVerticalPadding)
            .background(Color.buttonBgColor)
            .cornerRadius(textFieldCornerRadius)
    }
}

struct TextFieldComponents_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldComponents()
    }
}
