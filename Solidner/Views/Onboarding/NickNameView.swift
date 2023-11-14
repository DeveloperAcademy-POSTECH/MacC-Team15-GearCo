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
    private let warningMessageFontSize = 11.5
    private let buttonUpDuration = 0.1
    var nickNameViewCase = NickNameViewCase.babyName
    @StateObject private var textLimiter = TextLimiterOB()
    @StateObject private var keyboardHeightHelper = KeyboardHeightHelperOB()
    @FocusState private var isFocused: Bool
    @EnvironmentObject var user: UserOB
    
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
            OnboardingTitles(bigTitle: nickNameViewCase == .userName ? TextLiterals.NickName.bigUserNameTitle : TextLiterals.NickName.bigBabyNameTitle , isSmallTitleExist: false)
            TextFieldComponents().shortTextfield(placeHolder: TextLiterals.NickName.placeHolder, value: $textLimiter.value, isFocused: $isFocused)
                .padding(.top, textFieldTopPadding)
            if textLimiter.hasReachedLimit {
                withAnimation {
                    HStack {
                        Text(TextLiterals.NickName.warningMessage)
                            .foregroundColor(Color.warningMessageColor)
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
                ButtonComponents().smallButton(disabledCondition: textLimiter.value.isEmpty) {
                    switch nickNameViewCase {
                    case .userName :
                        user.nickName = textLimiter.value
                    case .babyName :
                        user.babyName = textLimiter.value
                    }
                }
                    .offset(y: isFocused ? -self.keyboardHeightHelper.keyboardHeight : 0)
                    .animation(.easeIn(duration: buttonUpDuration), value: keyboardHeightHelper.keyboardHeight)
            }
        }
    }
    enum NickNameViewCase {
        case userName
        case babyName
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView().environmentObject(UserOB())
    }
}
