//
//  FoodStartDateView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct FoodStartDateView: View {
    let datePickerTopPadding = 51.0
    @State private var solidStartDate = Date()
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader()
            viewBody()
        }
    }
    func viewBody() -> some View {
        return VStack {
            OnboardingTitles(bigTitle: TextLiterals.FoodStartDate.bigTitle, smallTitle: TextLiterals.FoodStartDate.smallTitle)
            DatePicker(selection: $solidStartDate, displayedComponents: .date){}
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .padding(.top, datePickerTopPadding)
            Spacer()
            ButtonComponents().bigButton(disabledCondition: false, action: {})
        }
    }
}

struct FoodStartDateView_Previews: PreviewProvider {
    static var previews: some View {
        FoodStartDateView()
    }
}
