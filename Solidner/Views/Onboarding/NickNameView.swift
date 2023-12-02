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
    @StateObject private var keyboardHeightHelper = KeyboardHeightHelperOB()
    @FocusState private var isFocused: Bool
//    @EnvironmentObject var user: UserOB
    @Binding var tempUserInfo: TempUserInfo
    @State private var babyNameViewIsPresented = false
    @State private var navigationIsPresented = false
    private let limit = 10
    @State private var inputText = ""
    @State private var hasReachedLimit = false
    
    
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
                    ButtonComponents().smallButton(disabledCondition: inputText.isEmpty) {
                        switch nickNameViewCase {
                        case .userName :
                            tempUserInfo.nickName = inputText
                            babyNameViewIsPresented = true
                        case .babyName :
                            tempUserInfo.babyName = inputText
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
            NickNameView(nickNameViewCase: .babyName, tempUserInfo: $tempUserInfo)
        }
        .navigationDestination(isPresented: $navigationIsPresented) {
            SoCuteNameView(tempUserInfo: $tempUserInfo)
        }
        .onTapGesture {
            if isFocused {
                isFocused = false
            }
        }
    }
    
    private func viewBody() -> some View {
        return VStack(spacing: 0) {
            OnboardingTitles(bigTitle: nickNameViewCase == .userName ? TextLiterals.NickName.bigUserNameTitle : TextLiterals.NickName.bigBabyNameTitle , smallTitle: "", isSmallTitleExist: false)
            TextFieldComponents().shortTextfield(placeHolder: TextLiterals.NickName.placeHolder, value: $inputText, isFocused: $isFocused)
                .onReceive(inputText.publisher.collect()) { collectionText in
                    let trimmedText = String(collectionText.prefix(limit))
                    if inputText != trimmedText {
                        hasReachedLimit = inputText.count > limit ? true : false
                        inputText = trimmedText
                    }
                }
                .padding(.top, textFieldTopPadding)
                HStack {
                    Text(TextLiterals.NickName.warningMessage)
                        .foregroundColor(hasReachedLimit ? ($inputText.wrappedValue.count < limit ? .clear : .accentColor1) : .clear)
                        .inputErrorFont()
                        .padding(.top, warningMessageTopPadding)
                        .padding(.leading, warningMessageLeadingPadding)
                    Spacer()
                }
            Spacer()
        }
    }
    enum NickNameViewCase {
        case userName
        case babyName
    }
}
