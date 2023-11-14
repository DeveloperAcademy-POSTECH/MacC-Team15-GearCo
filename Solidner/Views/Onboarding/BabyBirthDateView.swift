//
//  BabyBirthDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct BabyBirthDateView: View {
    let bigTitleColor = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1))
    let smallTitleColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.6)
    let cakeLabelFontSize = 32.0
    let onboardingTitlesTopPadding = 10.0
    let datePickerTopPadding = 70.0
    @State private var babyName = "찍무"
    @State private var babyBirthDate = Date()
    @EnvironmentObject var user: UserOB
    var body: some View {
        VStack(spacing: 0) {
           BackButtonHeader()
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
            ButtonComponents().bigButton(disabledCondition: false) {
                user.babyBirthDate = babyBirthDate
            }
        }
    }
}

struct BabyBirthDateView_Previews: PreviewProvider {
    static var previews: some View {
        BabyBirthDateView().environmentObject(UserOB())
    }
}
