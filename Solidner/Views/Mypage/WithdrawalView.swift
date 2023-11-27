//
//  WithdrawalView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct WithdrawalView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserOB
    @State private var showWithdrawalModalView = false
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0){
                BackButtonAndTitleHeader(title: "회원 탈퇴")
                viewBody()
                    .padding(horizontal: 20, top: 0, bottom: 6)
            }
            .background {
                Image(.withdrawalBg)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.getWidth(390), height: UIScreen.getWidth(844))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .sheet(isPresented: $showWithdrawalModalView) {
            if #available(iOS 16.4, *) {
                WithdrawalModalView()
                    .presentationDetents([.height(UIScreen.getHeight(637))])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(28)
            }
            else {
                WithdrawalModalView()
                    .presentationDetents([.height(UIScreen.getHeight(637))])
                    .presentationDragIndicator(.hidden)
            }
        }
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: 26) {
                Text("우리의 영원한\n\(user.nickName) 님!")
                    .headerFont2()
                    .foregroundStyle(Color.defaultText)
                    .multilineTextAlignment(.center)
                Text("솔리너와 함께한\n시간이 즐거웠길 바라요")
                    .headerFont4()
                    .foregroundStyle(Color.defaultText.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            Spacer()
            ButtonComponents().bigButton(title: "탈퇴하기", disabledCondition: false, action: {
                showWithdrawalModalView = true
            }, buttonColor: .buttonBgColor, titleColor: .secondaryText)
        }
    }
}

#Preview {
    WithdrawalView().environmentObject(UserOB())
}
