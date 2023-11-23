//
//  ChangeMonthModal.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

///
// TODO: ---
/// 디자인 시스템이 올라온 후,
/// [ ] 컴포넌트 정리하기
/// [ ] 하이파이로 수정하기
///   [ ] 쉐브론 눌렀을 때 선택되는 곳 어떻게 할지 정하기
/// [ ] 다른 뷰와 연결하기

import SwiftUI

struct ChangeMonthHalfModal: View {
    @Binding var selectedDate: Date
    let fromDate: Date

    var body: some View {
        ChangeMonthModal(selectedDate: $selectedDate, fromDate: fromDate)
            .presentationDetents([.medium])
            .modify { view in
                if #available(iOS 16.4, *) {
                    view.presentationCornerRadius(25)
                }
            }
    }
}

struct ChangeMonthModal: View {
    @Binding var selectedDate: Date
    @State private var selectingDate: Date

    enum K {
//        static var rootVStackSpacing: CGFloat { 30 }
        static var rootVStackSpacing: CGFloat { 18 }
        static var leftButtonIcon: String { "chevron.left" }
        static var rightButtonIcon: String { "chevron.right" }
        static var chevronColor: Color { Color.tertinaryText }

        static var monthTitleColor: Color { Color.defaultText }
        //TODO: - color 시스템 적용
        static var selectedCurrentMonthCircleColor: Color { Color.accentColor1 }
        static var selectedotherMonthCircleColor: Color { Color.black }

        static var monthColumnNumber: Int { 4 }
        static var monthTextColor: Color { Color.defaultText }
        static var disableTextColor: Color { .quarternaryText.opacity(0.8) }
        static var selectedMonthTextColor: Color { Color.defaultText_wh.opacity(0.8) }

        static var monthButtonSize: CGFloat { 74 }

        static var saveButtonBackgroundColor: Color { .primeText }
    }
    private let texts = TextLiterals.ChangeMonth.self

    let fromDate: Date
    var toDate: Date {
        let threeMonthAfter = Date().add(.month, value: 3)
        let threeMonthAfterFirstDay = Date.date(year: threeMonthAfter.year, month: threeMonthAfter.month, day: 1)!
        let twoMonthAfterLastDay = threeMonthAfterFirstDay.add(.day, value: -1)
        return twoMonthAfterLastDay
    }

    init(selectedDate: Binding<Date>, fromDate: Date) {
        self._selectedDate = selectedDate
        self._selectingDate = State(initialValue: selectedDate.wrappedValue)
        self.fromDate = fromDate
    }

    var body: some View {
        VStack(spacing: K.rootVStackSpacing) {
            monthTitleBar
            monthButtons
            saveButton
        }
    }
}

// MARK: - month  title bar
extension ChangeMonthModal {
    private var monthTitleBar: some View {
        HStack {
            if isFromDateBeforeCurrentYear {
                leftChevron
            }
            Spacer()
            monthTitle
            Spacer()
            if isToDateAfterCurrentYear {
                rightChevron
            }
        }
    }
    
    private var monthTitle: some View {
        Text(texts.currentYearText(of: selectingDate))
            .headerFont2()
            .foregroundStyle(K.monthTitleColor)
    }

    private var isFromDateBeforeCurrentYear: Bool {
        fromDate.year < selectingDate.year
    }

    private var leftChevron: some View {
        chevronView(direction: .left) {
            selectingDate = selectingDate.add(.year, value: -1)
        }
    }

    private var isToDateAfterCurrentYear: Bool {
        toDate.year > selectingDate.year
    }

    private var rightChevron: some View {
        chevronView(direction: .right) {
            selectingDate = selectingDate.add(.year, value: 1)
        }
    }

    enum Chevron {
        case left, right

        var iconImage: some View {
            switch self {
            case .left:
                return Image(systemName: "chevron.left")
            case .right:
                return Image(systemName: "chevron.right")
            }
        }
    }

    private func chevronView(direction chevron: Chevron, action: @escaping ()->Void) -> some View {
        chevron.iconImage
            .bold()
            .foregroundStyle(K.chevronColor)
            .onTapGesture {
                withAnimation {
                    action()
                }
            }
    }
}

// MARK: - month buttons

extension ChangeMonthModal {
    private var monthButtons: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: K.monthColumnNumber)

        return ZStack {
            LazyVGrid(columns: columns, spacing: .zero) {
                ForEach(1..<13) { number in
                    monthButton(of: number)
                }
            }
        }
    }

    private func monthButton(of number: Int) -> some View {
        let isSelectedCurrentMonth = Date().month == selectingDate.month && Date().year == selectingDate.year
        let isDisabled: Bool = {
            let itemYear = selectingDate.year
            let itemMonth = number
            let itemDate = Date.date(year: itemYear, month: itemMonth, day: 1)
            let fromFirstDay = Date.date(year: fromDate.year, month: fromDate.month, day: 1) ?? Date()
            return !(itemDate?.isInBetween(from: fromFirstDay, to: toDate) ?? true)
        }()
        let textColor = isDisabled ? K.disableTextColor : K.monthTextColor
        let isCurrentMonthSelected = number == selectingDate.month
        let selectedCircleColor = isSelectedCurrentMonth ?  K.selectedCurrentMonthCircleColor : K.selectedotherMonthCircleColor
        let backgroundCircle = Circle()
            .foregroundStyle(selectedCircleColor)
            .frame(width: K.monthButtonSize, height:K.monthButtonSize)

        return Button {
            withAnimation {
                selectingDate = Date.date(year: selectingDate.year, month: number, day: 1)!
            }
        } label: {
            Text(texts.monthText(of: number))
                .dayDisplayFont2()
                .if(isCurrentMonthSelected) { view in
                    view
                        .foregroundStyle(K.selectedMonthTextColor)
                        .background(backgroundCircle)
                }
                .foregroundStyle(textColor)
        }
        .frame(width: K.monthButtonSize, height:K.monthButtonSize)
        .disabled(isDisabled)
    }

    private var saveButton: some View {
        ButtonComponents(.big, 
                         title: texts.saveButtonText) {
            withAnimation {
                selectedDate = selectingDate
            }
        }
         .buttonColor(K.saveButtonBackgroundColor)
    }
}

struct ChangeMonthModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeMonthModal(selectedDate: .constant(Date()), fromDate: Date.date(year: 2023, month: 05, day: 20)!)
    }
}
