//
//  ReportIngredientView.swift
//  Solidner
//
//  Created by 황지우2 on 11/27/23.
//

import SwiftUI

struct ReportIngredientModalView: View {
    @FocusState private var reportFieldIsFocused: Bool
    @FocusState private var emilFieldIsFocused: Bool
    @State private var ingredientReportNote = ""
    @State private var receiveResultEmailAdress = ""
    @State private var goToFinishedSendingView = false
    @EnvironmentObject var user: UserOB
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            BackgroundView()
            if !goToFinishedSendingView {
                RootVStack {
                    Text("재료 리포트")
                        .headerFont1()
                        .foregroundStyle(Color.defaultText)
                    Text("더 많은 재료를 제공할 수 있도록\n솔리너에게 필요한 재료를 알려주세요")
                        .bodyFont1()
                        .foregroundStyle(Color.defaultText.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.top, 14)
                    reportNewIngredientComponent()
                        .padding(.top, 30)
                    ViewDivider(dividerCase: .thick)
                        .padding(.top, 26)
                    Spacer().frame(height: 26)
                    receiveReportResultComponent()
                        
                    Spacer()
                    ButtonComponents(.big, title: "보내기", disabledCondition: ingredientReportNote.isEmpty || receiveResultEmailAdress.isEmpty) {
                        goToFinishedSendingView = true
                    }
                }
                .padding(horizontal: 20, top: 49, bottom: 6)
            } else {
                FinishedSendingModalView(action: {
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    private func reportNewIngredientComponent() -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("필요한 재료")
                    .headerFont4()
                .foregroundStyle(Color.defaultText)
                Spacer()
            }
            TextFieldComponents().longTextfield(value: $ingredientReportNote, isFocused: $reportFieldIsFocused)
        }
    }
    private func receiveReportResultComponent() -> some View {
        RootVStack {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                        Text("소식 받기")
                            .headerFont4()
                            .foregroundStyle(Color.defaultText)
                        Text("\(user.nickName)님! 요청하신 재료가 추가되면 빠르게 \n이메일로 알려드릴게요.")
                            .bodyFont2()
                            .foregroundStyle(Color.defaultText.opacity(0.6))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 14)
                            .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            TextFieldComponents().shortTextfield(placeHolder: "이메일 주소", value: $receiveResultEmailAdress, isFocused: $emilFieldIsFocused)
                .padding(.top, 24)
        }
    }
}

struct FinishedSendingModalView: View {
    let action: () -> Void
    var body: some View {
        ZStack {
            BackgroundView()
            RootVStack {
                Spacer()
                Image(.lightning)
                Text("빛보다 빠르게\n전달 완료!")
                    .headerFont1()
                    .foregroundStyle(Color.defaultText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)
                Text("재료 요청을 빠르게 확인하고\n반영하도록 노력할게요")
                    .bodyFont1()
                    .foregroundStyle(Color.defaultText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.top, 26)
                Spacer()
                ButtonComponents(.big, title: "닫기", disabledCondition: false) {
                   action()
                }
            }
            .padding(horizontal: 20, top: 0, bottom: 6)
        }
    }
}

#Preview {
                ReportIngredientModalView().environmentObject(UserOB())
}
