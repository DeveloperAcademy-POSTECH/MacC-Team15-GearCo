//
//  StartDateSettingModal.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct StartDateSettingModal: View {
    @Binding var startDate: Date
    @State private var currentDate: Date
    @Environment(\.dismiss) private var dismiss

    init(startDate: Binding<Date>) {
        self._startDate = startDate
        self._currentDate = State(initialValue: startDate.wrappedValue)
    }

    var body: some View {
        VStack {
            Text("시작일 변경")
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
        startDate = currentDate
    }

}
