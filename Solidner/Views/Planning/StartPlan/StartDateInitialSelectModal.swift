//
//  StartDateInitialSelectModal.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI

// TODO: 날짜 제한 두기

struct StartDateInitialSelectModal: View {
    private let texts = TextLiterals.StartPlan.self
    @State private var currentDate = Date()
    @EnvironmentObject var user: UserOB
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            titleAndHint
            datePicker
            startButton
        }
        .padding(.vertical, K.rootVStackHorizontalPadding)
        .defaultHorizontalPadding()
        .withClearBackground(color: .secondBgColor)
    }

    private var titleAndHint: some View {
        TitleAndHintView(
            type: .center12,
            title: texts.selectStartDateModalTitleText,
            hint: texts.selectStartDateModalHintText
        )
        .padding(.top, K.titleAndHintPaddingTop)
        .padding(.bottom, K.titleAndHintPaddingBottom)
    }

    private var datePicker: some View {
        let dateRange = {
            let today = Date()
//            let oneYearAfter = Date.date(year: today.year + 1, month: today.month, day: today.day)!
            let firstDateOfThisMonth = Date.date(year: today.year, month: today.month, day: 1)!
            let lastDate = firstDateOfThisMonth
                .add(.month, value: +2)
                .add(.day, value: -1)
            return max(user.babyBirthDate, firstDateOfThisMonth)...lastDate
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

    // bottom padding 맞춰야할듯?
    private var startButton: some View {
        ButtonComponents(
            .big,
            title: texts.startButtonLabel(from: currentDate)) {
                // 다음 action
                dismiss()
            }
            .padding(.bottom, K.startButtonPaddingBottom)
    }
}

extension StartDateInitialSelectModal {
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

struct StartDateInitialSelectModal_Previews: PreviewProvider {
    static var previews: some View {
        StartDateInitialSelectModal().environmentObject(UserOB())
    }
}
