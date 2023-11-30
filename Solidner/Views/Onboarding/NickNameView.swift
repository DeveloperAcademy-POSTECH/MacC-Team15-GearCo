//
//  NickNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct NickNameView: View {
    private let textFieldTopPadding = 22.0
    private let warningMessageTopPadding = 12.0
    private let warningMessageLeadingPadding = 6.0
    private let buttonUpDuration = 0.05
    let nickNameViewCase: NickNameViewCase
    @StateObject private var textLimiter = TextLimiterOB()
    @StateObject private var keyboardHeightHelper = KeyboardHeightHelperOB()
    @FocusState private var isFocused: Bool
    @EnvironmentObject var user: UserOB
    @State private var babyNameViewIsPresented = false
    @State private var navigationIsPresented = false
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                ZStack {
                    BackgroundView()
                    VStack(spacing: 0) {
                        BackButtonOnlyHeader()
                        viewBody()
                            .padding(horizontal: 20, top: 14.88, bottom: 0)
                    }
                    .onAppear (perform : UIApplication.shared.hideKeyboard)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            VStack {
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
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
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
        return VStack(spacing: 0) {
            OnboardingTitles(bigTitle: nickNameViewCase == .userName ? TextLiterals.NickName.bigUserNameTitle : TextLiterals.NickName.bigBabyNameTitle , smallTitle: "", isSmallTitleExist: false)
            TextFieldComponents().shortTextfield(placeHolder: TextLiterals.NickName.placeHolder, value: $textLimiter.value, isFocused: $isFocused)
                .onChange(of: textLimiter.value) { newValue in
                    if textLimiter.value.count > 10 {
                        textLimiter.value = String(textLimiter.value.prefix(10))
                    }
                }

                .padding(.top, textFieldTopPadding)
            if textLimiter.hasReachedLimit {
                withAnimation {
                    HStack {
                        Text(TextLiterals.NickName.warningMessage)
                            .foregroundColor(Color.accentColor1)
                            .inputErrorFont()
                        .padding(.top, warningMessageTopPadding)
                        .padding(.leading, warningMessageLeadingPadding)
                        Spacer()
                    }
                }
            }
            Spacer()
//            HStack {
//                Spacer()
//                ButtonComponents().smallButton(disabledCondition: textLimiter.value.isEmpty) {
//                    switch nickNameViewCase {
//                    case .userName :
//                        user.nickName = textLimiter.value
//                        babyNameViewIsPresented = true
//                    case .babyName :
//                        user.babyName = textLimiter.value
//                        navigationIsPresented = true
//                    }
//                }
//                    .offset(y: isFocused ? -self.keyboardHeightHelper.keyboardHeight : 0)
//                    .animation(.easeIn(duration: buttonUpDuration), value: keyboardHeightHelper.keyboardHeight)
//            }
        }
    }
    enum NickNameViewCase {
        case userName
        case babyName
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView(nickNameViewCase: .userName).environmentObject(UserOB())
    }
}
