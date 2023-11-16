//
//  FoodStartDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct FoodStartDateView: View {
    private let datePickerTopPadding = 51.0
    @State private var solidStartDate = Date()
    @EnvironmentObject var user: UserOB
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader()
            viewBody()
        }
    }
    private func viewBody() -> some View {
        return VStack {
            OnboardingTitles(bigTitle: TextLiterals.FoodStartDate.bigTitle, smallTitle: TextLiterals.FoodStartDate.smallTitle)
            DatePicker(selection: $solidStartDate, displayedComponents: .date){}
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding(.top, datePickerTopPadding)
            Spacer()
            ButtonComponents().bigButton(disabledCondition: false) {
                user.solidStartDate = solidStartDate
            }
        }
    }
}

struct FoodStartDateView_Previews: PreviewProvider {
    static var previews: some View {
        FoodStartDateView()
    }
}
