//
//  StartDateInitialSelectModal.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI


struct StartDateInitialSelectModal: View {
    private let texts = TextLiterals.StartPlan.self
    @State private var currentDate = Date()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            header
            detail
            datePicker
            startButton
        }
        .padding()
        .padding(.top, 20)
        .background(Color.pink)
    }

    private var header: some View {
        Text(texts.selectStartDateModalHeaderText)
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
    }

    private var detail: some View {
        Text(texts.selectStartDateModalDetailText)
            .font(.body)
            .multilineTextAlignment(.center)
    }

    private var datePicker: some View {
        DatePicker(TextLiterals.emptyString, selection: $currentDate, displayedComponents: [.date])
            .labelsHidden()
            .datePickerStyle(.wheel)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
    }

    private var startButton: some View {
        ButtonComponents(.big,
                         title: texts.startButtonLabel) {

            dismiss()
        }
    }
}

struct StartDateInitialSelectModal_Previews: PreviewProvider {
    static var previews: some View {
        StartDateInitialSelectModal()
    }
}
