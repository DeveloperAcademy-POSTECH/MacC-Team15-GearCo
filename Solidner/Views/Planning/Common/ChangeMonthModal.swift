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
/// [ ] 다른 뷰와 연결하기

import SwiftUI

struct ChangeMonthModal: View {
    @Binding var selectedDate: Date
    @State private var selectingDate: Date
    
    private enum K {
        static var leftButtonIcon: String { "chevron.left" }
        static var rightButtonIcon: String { "chevron.right" }
        static var monthTitleColor: Color { Color.black }
        //TODO: - color 시스템 적용
        static var selectedCurrentMonthCircleColor: Color { Color.pink }
        static var selectedotherMonthCircleColor: Color { Color.black }
        static var chevronColor: Color { Color.black }
        static var monthColumnNumber: Int { 4 }
        static var monthTextColor: Color { Color.black }
        static var selectedMonthTextColor: Color { Color.white }
    }
    private let texts = TextLiterals.ChangeMonth.self

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._selectingDate = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack {
            monthTitleBar
            monthButtons
            saveButton
        }
    }

    private var monthTitleBar: some View {
        HStack {
            leftChevron
            Spacer()
            monthTitle
            Spacer()
            rightChevron
        }
    }

    private var leftChevron: some View {
        chevronView(direction: .left) {
            selectingDate = selectingDate.add(.year, value: -1)
        }
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
                return Image(systemName: K.leftButtonIcon)
            case .right:
                return Image(systemName: K.rightButtonIcon)
            }
        }
    }

    private func chevronView(direction chevron: Chevron, action: @escaping ()->Void) -> some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            chevron.iconImage
        }
        .foregroundStyle(K.chevronColor)
    }

    private var monthTitle: some View {
        Text(texts.currentYearText(of: selectingDate))
            .font(.title)
            .foregroundStyle(K.monthTitleColor)
    }

    private var monthButtons: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: K.monthColumnNumber)
        let isSelectedCurrentMonth = Date().month == selectingDate.month && Date().year == selectingDate.year
        return ZStack {
            LazyVGrid(columns: columns) {
                ForEach(1..<13) { number in
                    Button {
                        withAnimation {
                            selectingDate = Date.date(year: selectingDate.year, month: number, day: 1)!
                        }
                    } label: {
                        Text(texts.monthText(of: number))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .if(number == selectingDate.month) { view in
                                view
                                    .foregroundStyle(K.selectedMonthTextColor)
                                    .background(
                                    Circle()
                                        .foregroundStyle(
                                            isSelectedCurrentMonth ?  K.selectedCurrentMonthCircleColor : K.selectedotherMonthCircleColor
                                        )
                                )
                            }
                    }
                    .foregroundStyle(K.monthTextColor)
                }
            }
        }
    }

    private var saveButton: some View {
        ButtonComponents(.big, title: texts.saveButtonText) {
            withAnimation {
                selectedDate = selectingDate
            }
        }
    }
}

struct ChangeMonthModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeMonthModal(selectedDate: .constant(Date()))
    }
}
