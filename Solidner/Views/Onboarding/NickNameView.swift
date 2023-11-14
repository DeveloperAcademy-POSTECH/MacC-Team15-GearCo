//
//  NickNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct NickNameView: View {
    private let textFieldTopPadding = CGFloat(16)
    private let warningMessageTopPadding = CGFloat(12)
    private let warningMessageLeadingPadding = CGFloat(4)
    private let warningMessageColor = Color(#colorLiteral(red: 0.916901052, green: 0.4367357492, blue: 0.4184575677, alpha: 1))
    private let warningMessageFontSize = 11.5
    @StateObject private var textLimiter = TextLimiterOB()
    @StateObject private var keyboardHeightHelper = KeyboardHeightHelperOB()
    @FocusState private var isFocused: Bool
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                BackButtonHeader {
                    print("~~")
                }
                viewBody()
            }
            .onAppear (perform : UIApplication.shared.hideKeyboard)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func viewBody() -> some View {
        return VStack {
            OnboardingTitles(bigTitle: TextLiterals.NickName.bigTitle, isSmallTitleExist: false)
            TextFieldComponents().shortTextfield(placeHolder: TextLiterals.NickName.placeHolder, value: $textLimiter.value, isFocused: $isFocused)
                .padding(.top, textFieldTopPadding)
            if textLimiter.hasReachedLimit {
                withAnimation {
                    HStack {
                        Text(TextLiterals.NickName.warningMessage)
                            .foregroundColor(warningMessageColor)
                            .font(.system(size: warningMessageFontSize, weight: .semibold))
                        .padding(.top, warningMessageTopPadding)
                        .padding(.leading, warningMessageLeadingPadding)
                        Spacer()
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                ButtonComponents().smallButton(disabledCondition: textLimiter.value.isEmpty, action: {})
                    .offset(y: isFocused ? -self.keyboardHeightHelper.keyboardHeight : 0)
                    .animation(.easeIn(duration: 0.1), value: keyboardHeightHelper.keyboardHeight)
            }
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView()
    }
}
