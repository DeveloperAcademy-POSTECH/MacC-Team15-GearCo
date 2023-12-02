//
//  BabyBirthDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct BabyBirthDateView: View {
    private let cakeLabelFontSize = 32.0
    private let onboardingTitlesTopPadding = 4.0
    private let datePickerTopPadding = 86.0
    @State private var babyBirthDate = Date()
    @State private var navigationIsPresented = false
    @Binding var tempUserInfo: TempUserInfo
//    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                BackButtonOnlyHeader()
                viewBody()
                    .padding(horizontal: 20, top: 15.88, bottom: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigationIsPresented) {
            FoodStartDateView(tempUserInfo: $tempUserInfo)
        }
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            Text(TextLiterals.BabyBirthDate.cakeLabelText)
                .font(.custom(Text.FontWeightCase.bold.rawValue, size: 32))
            OnboardingTitles(alignmentCase: .center,
                             bigTitle: tempUserInfo.babyName+TextLiterals.BabyBirthDate.bigTitle,
                             smallTitle: TextLiterals.BabyBirthDate.smallTitle)
                            .padding(.top, onboardingTitlesTopPadding)
            DatePicker(selection: $babyBirthDate, in: ...Date(), displayedComponents: .date){}
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding(.top, datePickerTopPadding)
            Spacer()
            ButtonComponents(.big, disabledCondition: false, action: {
                tempUserInfo.babyBirthDate = babyBirthDate
                navigationIsPresented = true
            })
        }
    }
}
