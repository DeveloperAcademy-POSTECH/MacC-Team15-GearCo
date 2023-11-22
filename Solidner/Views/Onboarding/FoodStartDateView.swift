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
    @State private var navigationIsPresented = false
    @EnvironmentObject var user: UserOB
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader {
                presentationMode.wrappedValue.dismiss()
            }
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
            ButtonComponents(.big, disabledCondition: false) {
                user.solidStartDate = solidStartDate
                navigationIsPresented = true
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigationIsPresented) {
            OnboardingEndView()
        }
    }
}

struct FoodStartDateView_Previews: PreviewProvider {
    static var previews: some View {
        FoodStartDateView()
    }
}
