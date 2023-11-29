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
    
    // TODO: - 매직넘버 지우기
    var body: some View {
        ChangeMonthModal(selectedDate: $selectedDate, fromDate: fromDate)
            .presentationDetents([.height(429)])
            .modify { view in
                if #available(iOS 16.4, *) {
                    view.presentationCornerRadius(25)
                }
            }
    }
}

struct ChangeMonthModal: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    @State private var selectingDate: Date
    @State private var selectingYear: Int
    
    @State private var saveAction: () -> Void
    func saveAction(_ action: @escaping () -> Void) -> Self {
        var view = self
        view._saveAction = State(initialValue: action)
        return view
    }
    
    private let texts = TextLiterals.ChangeMonth.self
    
    let fromDate: Date
    var toDate: Date {
        let threeMonthAfter = Date().add(.month, value: 3)
        let threeMonthAfterFirstDay = Date.date(year: threeMonthAfter.year, month: threeMonthAfter.month, day: 1)!
        let twoMonthAfterLastDay = threeMonthAfterFirstDay.add(.day, value: -1)
        return twoMonthAfterLastDay
    }
    
    init(selectedDate: Binding<Date>, fromDate: Date, action: @escaping () -> Void = {}) {
        self._selectedDate = selectedDate
        self._selectingDate = State(initialValue: selectedDate.wrappedValue)
        self._selectingYear = State(initialValue: selectedDate.wrappedValue.year)
        self.fromDate = fromDate
        self._saveAction = State(initialValue: action)
    }
    
    var body: some View {
        VStack(spacing: K.rootVStackSpacing) {
            Spacer().frame(height: 30)
            monthTitleBar
            monthButtons
            Spacer()
            saveButton
        }
        .defaultHorizontalPadding()
        .withClearBackground(color: .secondBgColor)
    }
}

// MARK: - month  title bar
extension ChangeMonthModal {
    private var monthTitleBar: some View {
        let isFromDateBeforeCurrentYear = fromDate.year < selectingYear
        let isToDateAfterCurrentYear = toDate.year > selectingYear
        
        return HStack {
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
        Text(texts.currentYearText(of: selectingYear))
            .customFont(.header2, color: K.monthTitleColor)
    }
    
    private var leftChevron: some View {
        chevronView(direction: .left) {
            selectingYear -= 1
        }
    }
    
    
    private var rightChevron: some View {
        chevronView(direction: .right) {
            selectingYear += 1
        }
    }
    
    #warning("밖으로 빼든가 매직스트링 지우든가")
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
            LazyVGrid(columns: columns, spacing: K.monthVGridSpacing) {
                ForEach(1..<13) { number in
                    monthButton(of: number)
                }
            }
        }
    }
    
    private func monthButton(of number: Int) -> some View {
        let isSelectedCurrentMonth = Date().month == selectingDate.month && Date().year == selectingYear
        let isDisabled: Bool = {
            let itemYear = selectingYear
            let itemMonth = number
            let itemDate = Date.date(year: itemYear, month: itemMonth, day: 1)
            let fromFirstDay = Date.date(year: fromDate.year, month: fromDate.month, day: 1) ?? Date()
            return !(itemDate?.isInBetween(from: fromFirstDay, to: toDate) ?? true)
        }()
        let textColor = isDisabled ? K.disableTextColor : K.monthTextColor
        let isCurrentMonthSelected = number == selectingDate.month && selectingDate.year == selectingYear
        let selectedCircleColor = isSelectedCurrentMonth ?  K.selectedCurrentMonthCircleColor : K.selectedotherMonthCircleColor
        let backgroundCircle = Circle()
            .foregroundStyle(selectedCircleColor)
            .frame(width: K.monthButtonSize, height:K.monthButtonSize)
        
        return Button {
            withAnimation {
                selectingDate = Date.date(year: selectingDate.year, month: number, day: selectedDate.day)!
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
        let isDisabled = selectingDate.year != selectingYear
        return ButtonComponents(
            .big,
            title: texts.saveButtonText,
            disabledCondition: isDisabled) {
                withAnimation {
                    selectedDate = selectingDate
                    saveAction()
                    dismiss()
                }
            }
            .buttonColor(K.saveButtonBackgroundColor)
    }
}

extension ChangeMonthModal {
    enum K {
        // static var rootVStackSpacing: CGFloat { 30 }
        static var rootVStackSpacing: CGFloat { 18 }
        static var chevronColor: Color { Color.tertinaryText }
        
        static var monthTitleColor: Color { Color.defaultText }
        //TODO: - color 시스템 적용
        static var selectedCurrentMonthCircleColor: Color { Color.accentColor1 }
        static var selectedotherMonthCircleColor: Color { Color.primeText }
        
        static var monthColumnNumber: Int { 4 }
        static var monthVGridSpacing: CGFloat { 4 }
        static var monthTextColor: Color { Color.defaultText }
        static var disableTextColor: Color { .quarternaryText.opacity(0.8) }
        //        static var selectedMonthTextColor: Color { Color.defaultText_wh.opacity(0.8) }
        static var selectedMonthTextColor: Color { Color.defaultText_wh }
        
        static var monthButtonSize: CGFloat { 74 }
        
        static var saveButtonBackgroundColor: Color { .primeText }
    }
}

struct ChangeMonthModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeMonthModal(selectedDate: .constant(Date()), fromDate: Date.date(year: 2022, month: 12, day: 20)!)
    }
}
