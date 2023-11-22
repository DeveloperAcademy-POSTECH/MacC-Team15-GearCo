//
//  ChangeMonthModal.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct ChangeMonthModal: View {
    @Binding var selectedDate: Date
    @State private var selectingDate: Date
    
    private enum K {
        static var leftButtonIcon: String { "chevron.left" }
        static var rightButtonIcon: String { "chevron.right" }
        static var monthTitleColor: Color { Color.black }
    }
    private let texts = TextLiterals.ChangeMonth.self

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._selectingDate = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack {
            monthTitleBar
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

}

struct ChangeMonthModal_Previews: PreviewProvider {
    static var previews: some View {
        ChangeMonthModal(selectedDate: .constant(Date()))
    }
}
