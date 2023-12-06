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
    private let limit = 10
    @State private var showBabyBirthDateModal = false
    @State private var showSolidStartDateModal = false
    @State private var showAddMoreUserFYIModal = false
    @State private var showFailureAlert = false
    @State private var err: Error?
    
    @State private var updatedBabyBirthDate = Date()
    @State private var updatedSolidStartDate = Date()
    @State private var nickNameInputText = ""
    @State private var babyNameInputText = ""
    
    @State private var nickNameHasReachedLimit = false
    @State private var babyNameHasReachedLimit = false
    @FocusState private var isNicknameFocused: Bool
    @FocusState private var isBabynameFocused: Bool
    @EnvironmentObject var user: UserOB
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        GeometryReader { _ in
            ZStack {
                BackgroundView()
                VStack(spacing: 0) {
                    BackButtonAndTitleHeader(title: "회원정보 수정")
                    viewBody()
                        .padding(horizontal: 20, top: 26.88, bottom: 6)
                }.task {
                    nickNameInputText = user.nickName
                    babyNameInputText = user.babyName
                    updatedBabyBirthDate = user.babyBirthDate
                    updatedSolidStartDate = user.solidStartDate
                }
            }
            .sheet(isPresented: $showBabyBirthDateModal, content: {
                if #available(iOS 16.4, *) {
                    DateUpdateModalView(dateCase: .babyBirth, updatedDate: $updatedBabyBirthDate)
                        .presentationDetents([.height(UIScreen.getHeight(498))])
                        .presentationDragIndicator(.hidden)
                        .presentationCornerRadius(28)
                }
                else {
                    DateUpdateModalView(dateCase: .babyBirth, updatedDate: $updatedBabyBirthDate)
                        .presentationDetents([.height(UIScreen.getHeight(498))])
                        .presentationDragIndicator(.hidden)
                }
            })
            .sheet(isPresented: $showSolidStartDateModal, content: {
                if #available(iOS 16.4, *) {
                    DateUpdateModalView(dateCase: .solidStart, updatedDate: $updatedSolidStartDate)
                        .presentationDetents([.height(UIScreen.getHeight(498))])
                        .presentationDragIndicator(.hidden)
                        .presentationCornerRadius(28)
                }
                else {
                    DateUpdateModalView(dateCase: .solidStart, updatedDate: $updatedSolidStartDate)
                        .presentationDetents([.height(UIScreen.getHeight(498))])
                        .presentationDragIndicator(.hidden)
                }
            })
            .sheet(isPresented: $showAddMoreUserFYIModal, content: {
                if #available(iOS 16.4, *) {
                    AddMoreUserFYIModalView()
                        .presentationDetents([.height(UIScreen.getHeight(415))])
                        .presentationDragIndicator(.hidden)
                        .presentationCornerRadius(28)
                }
                else {
                    AddMoreUserFYIModalView()
                        .presentationDetents([.height(UIScreen.getHeight(415))])
                        .presentationDragIndicator(.hidden)
                }
            })
        }
        .onTapGesture {
            if isBabynameFocused {
                isBabynameFocused = false
            }
            if isNicknameFocused {
                isNicknameFocused = false
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    private func viewBody() -> some View {
        var disableCondition: Bool {
            nickNameInputText.isEmpty || nickNameInputText.count > limit || babyNameInputText.isEmpty || babyNameInputText.count > limit
        }
                
        return VStack(spacing: 0) {
            userInfoUpdateList()
            Spacer()
            VStack {
                Button(action: {
                    showAddMoreUserFYIModal = true
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
            ButtonComponents(.big, title: "수정 완료", disabledCondition: disableCondition) {
                Task {
                    do {
                        try await FirebaseManager.shared.updateUser(user.email, nickName: nickNameInputText, babyName: babyNameInputText, babyBirth: updatedBabyBirthDate, solidStart: updatedSolidStartDate)
                        user.babyName = babyNameInputText
                        user.nickName = nickNameInputText
                        user.babyBirthDate = updatedBabyBirthDate
                        user.solidStartDate = updatedSolidStartDate
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        showFailureAlert = true
                        self.err = error
                    }
                }
            }.padding(.top, 40)
        }.alert("에러 발생", isPresented: $showFailureAlert, presenting: err) { err in
            Button("확인") { showFailureAlert = false }
        } message: { error in
            Text("회원 정보 수정 중 오류 발생.\n인터넷 연결을 확인해 보시고, 재시도 해 주세요.")
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
            TextFieldComponents().shortTextfield(placeHolder: "", value: $nickNameInputText, isFocused: $isNicknameFocused)
                .onReceive(nickNameInputText.publisher.collect()) { collectionText in
                    let trimmedText = String(collectionText.prefix(limit))
                    if nickNameInputText != trimmedText {
                        nickNameHasReachedLimit = (nickNameInputText.count > limit || nickNameInputText.isEmpty) ? true : false
                        nickNameInputText = trimmedText
                    }
                }
            HStack {
                Text(TextLiterals.NickName.warningMessage)
                    .foregroundColor(nickNameHasReachedLimit ? ($nickNameInputText.wrappedValue.count < limit ? .clear : .accentColor1) : .clear)
                    .inputErrorFont()
                    .padding(.top, warningMessageTopPadding)
                    .padding(.leading, warningMessageLeadingPadding)
                Spacer()
            }
        }
    }
    private func babyNameTextField() -> some View {
        VStack {
            TextFieldComponents().shortTextfield(placeHolder: "", value: $babyNameInputText, isFocused: $isBabynameFocused)
                .onReceive(babyNameInputText.publisher.collect()) { collectionText in
                    let trimmedText = String(collectionText.prefix(limit))
                    if babyNameInputText != trimmedText {
                        babyNameHasReachedLimit = (babyNameInputText.count > limit || babyNameInputText.isEmpty) ? true : false
                        babyNameInputText = trimmedText
                    }
                }
            HStack {
                Text(TextLiterals.NickName.warningMessage)
                    .foregroundColor(babyNameHasReachedLimit ? ($babyNameInputText.wrappedValue.count < limit ? .clear : .accentColor1) : .clear)
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
                Text(userInfoCase == . babyBirthDate ? updatedBabyBirthDate.formatted(.yyyyMMdd_fullKorean) : updatedSolidStartDate.formatted(.yyyyMMdd_fullKorean))
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
