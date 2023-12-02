//
//  FoodStartDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct FoodStartDateView: View {
    private let datePickerTopPadding = 64.0
    @State private var solidStartDate = Date()
    @State private var navigationIsPresented = false
//    @EnvironmentObject var user: UserOB
    @Binding var tempUserInfo: TempUserInfo
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                BackButtonOnlyHeader()
                viewBody()
                    .padding(horizontal: 20, top: 15.88, bottom: 20)
            }
        }
    }
    private func viewBody() -> some View {
        return VStack {
            OnboardingTitles(bigTitle: TextLiterals.FoodStartDate.bigTitle, smallTitle: TextLiterals.FoodStartDate.smallTitle)
            DatePicker(selection: $solidStartDate, in: tempUserInfo.babyBirthDate..., displayedComponents: .date){}
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding(.top, datePickerTopPadding)
            Spacer()
            ButtonComponents(.big, disabledCondition: false) {
                tempUserInfo.solidStartDate = solidStartDate
                navigationIsPresented = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigationIsPresented) {
            OnboardingEndView(tempUserInfo: $tempUserInfo)
        }
    }
}
