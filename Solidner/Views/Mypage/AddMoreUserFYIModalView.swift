//
//  AddMoreUserFYIModalView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct AddMoreUserFYIModalView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                Image(.addUserIcon)
                Text("양육자와 아이추가는\n어떻게 하나요?")
                    .headerFont2()
                    .foregroundStyle(Color.primeText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                Text("솔리너는 아직, 단일 구성원까지\n추가할 수 있어요. 조금만 기다려주시면\n곧 빠르게 준비할게요!")
                    .bodyFont1()
                    .foregroundStyle(Color.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                Spacer()
                ButtonComponents(.big, title: "닫기", disabledCondition: false) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(horizontal: 20, top: 40, bottom: 6)
        }
    }
}

#Preview {
    AddMoreUserFYIModalView()
}
