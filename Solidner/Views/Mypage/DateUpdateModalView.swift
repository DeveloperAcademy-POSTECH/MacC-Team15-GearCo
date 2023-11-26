//
//  BabyBirthDateUpdateModalView.swift
//  Solidner
//
//  Created by 황지우2 on 11/25/23.
//

import SwiftUI

struct DateUpdateModalView: View {
    let dateCase: DateCase
    @Binding var updatedDate: Date
    @State private var updatedInput = Date()
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                Text(dateCase.rawValue)
                    .headerFont2()
                    .foregroundStyle(Color.defaultText.opacity(0.8))
                Text(dateCase == .babyBirth ? "아이의 생년월일을 입력해주세요" : "이유식 계획을 시작할 날짜를 입력해주세요")
                    .bodyFont1()
                    .foregroundStyle(Color.secondaryText).opacity(0.6)
                    .padding(.top, 12)
                DatePicker(selection: $updatedInput, in: ...Date(), displayedComponents: .date){}
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding(.top, 28)
                Spacer()
                ButtonComponents(.big, title: "완료", disabledCondition: false) {
                    updatedDate = updatedInput
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(horizontal: 20, top: 50, bottom: 6)
        }
        .onAppear {
            updatedInput = updatedDate
        }
    }
    enum DateCase: String {
        case babyBirth = "생일을 변경할게요"
        case solidStart = "이유식 시작일을 변경할게요"
    }
}

//#Preview {
//    DateUpdateModalView()
//}
