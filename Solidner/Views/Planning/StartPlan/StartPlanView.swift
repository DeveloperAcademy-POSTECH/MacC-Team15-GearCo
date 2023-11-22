//
//  StartPlanView.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI

struct StartPlanView: View {
    private let texts = TextLiterals.StartPlan.self
    @State private var isStartTapped = false

    var body: some View {
        VStack {
            Spacer()
            header
            detail
            Spacer()
            goToPlanButton
            Spacer()
        }
    }

    private var header: some View {
        Text(texts.noWorriesJustStartHeaderText)
            .font(.largeTitle.bold())
            .multilineTextAlignment(.center)
    }

    private var detail: some View {
        Text(texts.noWorriesJustStartDetailText)
            .font(.body)
            .multilineTextAlignment(.center)
    }

    private var goToPlanButton: some View {
        ButtonComponents(.small,
                         title: texts.goToPlanButtonText) {
            isStartTapped = true
        }
             .sheet(isPresented: $isStartTapped) {
                 if #available(iOS 16.4, *) {
                     StartDateInitialSelectModal()
                         .presentationDetents([.medium])
                         .presentationCornerRadius(25)
                 } else {
                     StartDateInitialSelectModal()
                         .presentationDetents([.medium])

                 }
             }
    }
}

struct StartPlanView_Previews: PreviewProvider {
    static var previews: some View {
        StartPlanView()
    }
}

