//
//  NickNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct NickNameView: View {
    private let textFieldTopPadding = 16.0
    private let warningMessageTopPadding = 12.0
    private let warningMessageLeadingPadding = 4.0
    private let warningMessageFontSize = 11.5
    private let buttonUpDuration = 0.1
    var nickNameViewCase = NickNameViewCase.userName
    @StateObject private var textLimiter = TextLimiterOB()
    @StateObject private var keyboardHeightHelper = KeyboardHeightHelperOB()
    @FocusState private var isFocused: Bool
    @EnvironmentObject var user: UserOB
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var babyNameViewIsPresented = false
    @State private var navigationIsPresented = false
    
    var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                BackButtonHeader {
                    presentationMode.wrappedValue.dismiss()
                }
                viewBody()
            }
            .onAppear (perform : UIApplication.shared.hideKeyboard)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $babyNameViewIsPresented) {
            NickNameView(nickNameViewCase: .babyName)
        }
        .navigationDestination(isPresented: $navigationIsPresented) {
            SoCuteNameView()
        }
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
                        babyNameViewIsPresented = true
                    case .babyName :
                        user.babyName = textLimiter.value
                        navigationIsPresented = true
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
