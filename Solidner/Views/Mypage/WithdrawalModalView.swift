//
//  WithdrawalModalView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct WithdrawalModalView: View {
    @State private var reminderChecked = false
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
        Button(action: {
            //🔴 서버 회원탈퇴 코드
        }, label: {
            Text("탈퇴하기")
                .buttonFont()
                .foregroundStyle(Color.defaultText_wh)
                .symmetricBackground(HPad: 40.5, VPad: 17, color: .accentColor1.opacity(reminderChecked ? 1.0 : 0.2), radius: 60)
        })
        .disabled(!reminderChecked)
    }
    private enum ReminderCase: String {
        case babyInfo = "아이 정보(이름, 생년월일)"
        case solidInfo = "이유식 정보(시작일, 전체 계획)"
        case ingredientInfo = "재료 정보(테스트 재료, 재료 반응, 먹인 재료)"
    }
}

#Preview {
    WithdrawalModalView()
}
