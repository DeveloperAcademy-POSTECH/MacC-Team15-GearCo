//
//  WithdrawalModalView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct WithdrawalModalView: View {
    @State private var reminderChecked = false
    @EnvironmentObject var user: UserOB
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                Image(.leafMotif)
                Text("탈퇴 전 사라지는 \n정보를 꼭 확인해주세요")
                    .headerFont2()
                    .foregroundStyle(Color.defaultText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 14)
                reminderList()
                    .padding(.top, 30)
                remindCheckButton()
                    .padding(.top, 36)
                
                Spacer()
                
                Text("탈퇴하면 며칠간 재가입할 수 없어요")
                    .customFont(.clickableText2, color: .primeText.opacity(0.4))
                    .padding(.bottom, 15)
                
                withdrawalButton()
            }
            .padding(horizontal: 20, top: 40, bottom: 26)
        }
    }
    private func reminderList() -> some View {
        VStack(spacing: 12) {
            reminderItem(reminderCase: .babyInfo)
            reminderItem(reminderCase: .solidInfo)
            reminderItem(reminderCase: .ingredientInfo)
        }
    }
    private func reminderItem(reminderCase: ReminderCase) -> some View {
        Text(reminderCase.rawValue)
            .bodyFont2()
            .foregroundStyle(Color.defaultText.opacity(0.6))
            .padding(.vertical, 23)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.defaultText_wh, strokeBorder: Color.listStrokeColor, lineWidth: 2)
            )
    }
    private func remindCheckButton() -> some View {
        Button(action: {
            reminderChecked.toggle()
        }, label: {
            HStack(spacing: 8) {
                Image(reminderChecked ? .circleCheckOn : .circleCheckOff)
                Text("유의사항을 확인했어요")
                    .headerFont5()
                    .foregroundStyle(Color.tertinaryText)
            }
        })
    }
    private func withdrawalButton() -> some View {
        Button {
            // TODO: 서버 회원탈퇴
            Task {
                do {
                    try await FirebaseManager.shared.withdrawUser(user.email)
                    
                    UserDefaults().set("", forKey: "email")
                    UserDefaults().set("", forKey: "AppleID")
                    UserDefaults().set("", forKey: "babyName")
                    UserDefaults().set("", forKey: "nickName")
                    UserDefaults().set(false, forKey: "isAgreeToAdvertising")
                    UserDefaults().set(Date(), forKey: "babyBirthDate")
                    UserDefaults().set(Date(), forKey: "solidStartDate")
                } catch {
                    print("회원 탈퇴 중 에러 발생: \(error.localizedDescription)")
                }
            }
        } label: {
            Text("탈퇴하기")
                .buttonFont()
                .foregroundStyle(Color.defaultText_wh)
                .symmetricBackground(HPad: 40.5, VPad: 17, color: .accentColor1.opacity(reminderChecked ? 1.0 : 0.2), radius: 60)
        }
        .disabled(!reminderChecked)
    }
    private enum ReminderCase: String {
        case babyInfo = "아이 정보(이름, 생년월일)"
        case solidInfo = "이유식 정보(시작일, 전체 계획)"
        case ingredientInfo = "재료 정보(테스트 재료, 재료 반응, 먹인 재료)"
    }
}

#Preview {
    WithdrawalModalView().environmentObject(UserOB())
}
