//
//  UserInfoUpdateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/24.
//

import SwiftUI

struct UserInfoUpdateView: View {
    private let warningMessageTopPadding = 9.0
    private let warningMessageLeadingPadding = 6.0
    @State private var showBabyBirthDateModal = false
    @State private var showSolidStartDateModal = false
    @State private var showAddMoreUserFYIModal = false
    @StateObject private var nickNameTextLimiter = TextLimiterOB()
    @StateObject private var babyNameTextLimiter = TextLimiterOB()
    @FocusState private var isNicknameFocused: Bool
    @FocusState private var isBabynameFocused: Bool
    @EnvironmentObject var user: UserOB
    var body: some View {
        GeometryReader { _ in
            ZStack {
                BackgroundView()
                VStack(spacing: 0) {
                    BackButtonHeader(action: {
                        //Navigate back
                    }, title: "회원 정보 수정")
                    viewBody()
                        .padding(horizontal: 20, top: 40, bottom: 6)
                }
            }
        }
        .onAppear {
            nickNameTextLimiter.value = user.nickName
            babyNameTextLimiter.value = user.babyName
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            userInfoUpdateList()
            Spacer()
            VStack {
                Button(action: {
                    
                }){
                    VStack(spacing: 3) {
                        Text("양육자, 아이 추가를 찾으시나요?")
                            .clickableTextFont2()
                        .foregroundColor(.tertinaryText)
                        Rectangle()
                            .fill(Color.tertinaryText)
                            .frame(width: 166, height: 1)
                    }
                }
            }
            ButtonComponents(.big, title: "수정 완료", disabledCondition: false) {
                // AppStorage 정보 저장 및 데이터 업데이트 (서버, AppStorage)
            }
            .padding(.top, 40)
        }
    }
    private func userInfoUpdateList() -> some View {
        VStack(spacing: 40) {
            userInfoLabelAndItem(userInfoCase: .nickName)
                .padding(.bottom, -26)
            userInfoLabelAndItem(userInfoCase: .babyName)
                .padding(.bottom, -26)
            userInfoLabelAndItem(userInfoCase: .babyBirthDate)
            userInfoLabelAndItem(userInfoCase: .solidStartDate)
        }
    }
    private func userInfoLabelAndItem(userInfoCase: UserInfoCase) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(userInfoCase.rawValue)
                .headerFont4()
            .foregroundColor(.defaultText.opacity(0.8))
            switch userInfoCase {
            case .nickName:
                nickNameTextField()
            case .babyName:
                babyNameTextField()
            default:
                dateLabelButton(userInfoCase: userInfoCase)
            }
        }
    }
    private func nickNameTextField() -> some View {
        VStack {
            TextFieldComponents().shortTextfield(placeHolder: "", value: $nickNameTextLimiter.value, isFocused: $isNicknameFocused)
            HStack {
                Text(TextLiterals.NickName.warningMessage)
                    .foregroundColor(nickNameTextLimiter.hasReachedLimit ? .accentColor1 : .clear)
                    .inputErrorFont()
                    .padding(.top, warningMessageTopPadding)
                    .padding(.leading, warningMessageLeadingPadding)
                Spacer()
            }
        }
    }
    private func babyNameTextField() -> some View {
        VStack {
            TextFieldComponents().shortTextfield(placeHolder: "", value: $babyNameTextLimiter.value, isFocused: $isBabynameFocused)
            HStack {
                Text(TextLiterals.NickName.warningMessage)
                    .foregroundColor(babyNameTextLimiter.hasReachedLimit ? .accentColor1 : .clear)
                    .inputErrorFont()
                    .padding(.top, warningMessageTopPadding)
                    .padding(.leading, warningMessageLeadingPadding)
                Spacer()
            }
        }
    }
    private func dateLabelButton(userInfoCase: UserInfoCase) -> some View {
        Button(action: {
            switch userInfoCase {
            case .babyBirthDate:
                return showBabyBirthDateModal = true
            case .solidStartDate:
                return showSolidStartDateModal = true
            default:
                return
            }
        }){
            HStack {
                Text(userInfoCase == . babyBirthDate ? user.babyBirthDate.formatted(.yyyyMMdd_fullKorean) : user.solidStartDate.formatted(.yyyyMMdd_fullKorean))
                    .bodyFont2()
                    .foregroundColor(.defaultText)
                Spacer()
            }
            .padding(.vertical, 19)
            .padding(.leading, 16)
            .background(Color.buttonBgColor)
            .cornerRadius(12)
        }
    }
    private enum UserInfoCase: String {
        case nickName = "내 닉네임"
        case babyName = "자녀 이름"
        case babyBirthDate = "자녀 생일"
        case solidStartDate = "이유식 시작일"
    }
}

struct UserInfoUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoUpdateView().environmentObject(UserOB())
    }
}
