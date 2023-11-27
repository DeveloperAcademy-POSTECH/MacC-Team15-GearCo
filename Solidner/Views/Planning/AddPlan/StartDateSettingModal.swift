//
//  StartDateSettingModal.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct StartDateSettingModal: View {
    @ObservedObject var mealOB: MealOB
    @EnvironmentObject var user: UserOB
    @State private var currentDate: Date
    @Environment(\.dismiss) private var dismiss
    private let texts = TextLiterals.MealDetail.self

    init(mealOB: MealOB) {
        self.mealOB = mealOB
        self._currentDate = State(initialValue: mealOB.startDate)
    }

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            titleAndHintView
            datePicker
            saveButton
        }
        .defaultHorizontalPadding()
        .withClearBackground(color: .secondBgColor)
    }

    private var titleAndHintView: some View {
        TitleAndHintView(
            type: .center12,
            title: texts.changeStartDateText,
            hint: texts.changeStartDateDetailText
        )
        .padding(.top, K.titleAndHintPaddingTop)
        .padding(.bottom, K.titleAndHintPaddingBottom)
    }
    
    private var datePicker: some View {
        let dateRange = {
            let today = Date()
            let currentMonthFirst = Date.date(year: today.year, month: today.month, day: 1)!
            let possibleNextLastDay = Date.date(year: today.year, month: today.month+3, day: 1) ?? Date()
            let possibleLastDay = possibleNextLastDay.add(.day, value: -1)
            let startDay = max(currentMonthFirst, user.solidStartDate)
            return startDay...possibleLastDay
        }()
        
        return DatePicker(
            TextLiterals.emptyString,
            selection: $currentDate,
            in: dateRange,
            displayedComponents: [.date]
        )
        .labelsHidden()
        .datePickerStyle(.wheel)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: K.datePickerBackgroundCornerRadius))
        .padding(.bottom, K.datePickerPaddingBottom)
    }
    
    private var saveButton: some View {
        ButtonComponents(
            .big,
            title: texts.saveButtonText) {
                mealOB.set(startDate: currentDate)
                dismiss()
            }
            .padding(.bottom, K.startButtonPaddingBottom)
        
    }
}

extension StartDateSettingModal {
    private enum K {
        static var rootVStackHorizontalPadding: CGFloat { 20 }
        static var backgroundColor: Color { .secondBgColor }
        static var titleAndHintPaddingTop: CGFloat { 50 }
        static var titleAndHintPaddingBottom: CGFloat { 28 }
        static var datePickerBackgroundCornerRadius: CGFloat { 12 }
        static var datePickerPaddingBottom: CGFloat { 48 }
        static var startButtonPaddingBottom: CGFloat { 48 }

    }
}
struct StartDateSettingModal_Previews: PreviewProvider {
    static var previews: some View {
        StartDateSettingModal(mealOB: MealOB(mealPlan: MealPlan.mockMealsOne.first!, cycleGap: .four))
    }
}
