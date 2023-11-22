//
//  BabyBirthDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct BabyBirthDateView: View {
    private let cakeLabelFontSize = 32.0
    private let onboardingTitlesTopPadding = 10.0
    private let datePickerTopPadding = 70.0
    @State private var babyName = "찍무"
    @State private var babyBirthDate = Date()
    @State private var navigationIsPresented = false
    @State private var goBackToBabyNameView = false
    @EnvironmentObject var user: UserOB
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 0) {
           BackButtonHeader {
               goBackToBabyNameView = true
           }
            viewBody()
        }
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            Text(TextLiterals.BabyBirthDate.cakeLabelText)
                .font(.system(size: cakeLabelFontSize, weight: .bold))
            OnboardingTitles(alignmentCase: .center, bigTitle: user.babyName+TextLiterals.BabyBirthDate.bigTitle , smallTitle: TextLiterals.BabyBirthDate.smallTitle)
                .padding(.top, onboardingTitlesTopPadding)
            DatePicker(selection: $babyBirthDate, in: ...Date(), displayedComponents: .date){}
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding(.top, datePickerTopPadding)
            Spacer()
            ButtonComponents(.big, disabledCondition: false, action: {
                user.babyBirthDate = babyBirthDate
                navigationIsPresented = true
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigationIsPresented) {
            FoodStartDateView()
        }
        .navigationDestination(isPresented: $goBackToBabyNameView) {
            NickNameView(nickNameViewCase: .babyName)
        }
    }
}

struct BabyBirthDateView_Previews: PreviewProvider {
    static var previews: some View {
        BabyBirthDateView().environmentObject(UserOB())
    }
}
