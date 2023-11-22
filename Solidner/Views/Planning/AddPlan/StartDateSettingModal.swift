//
//  StartDateSettingModal.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct StartDateSettingModal: View {
    @ObservedObject var planOB: MealOB
    @State private var currentDate: Date
    @Environment(\.dismiss) private var dismiss
    private let texts = TextLiterals.MealDetail.self

    init(planOB: MealOB) {
        self.planOB = planOB
        self._currentDate = State(initialValue: planOB.startDate)
    }

    var body: some View {
        VStack {
            Text(texts.changeStartDateText)
                .font(.title3.bold())
            Text(texts.changeStartDateDetailText)
            DatePicker("", selection: $currentDate, displayedComponents: [.date])
                .labelsHidden()
                .datePickerStyle(.wheel)
            Button("저장") {
                setStartDate()
                dismiss()
            }
        }
    }

    private func setStartDate() {
        planOB.set(startDate: currentDate)
    }
}

struct StartDateSettingModal_Previews: PreviewProvider {
    static var previews: some View {
        StartDateSettingModal(planOB: MealOB())
    }
}
