//
//  OnboardingEndView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct OnboardingEndView: View {
    @AppStorage("isOnboardingOn") var isOnboardingOn = true
    var body: some View {
        viewBody()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    private func viewBody() -> some View {
        return VStack(spacing: 0) {
            Spacer()
            OnboardingTitles(alignmentCase: .center, bigTitle: TextLiterals.OnboardingEnd.bigTitle, smallTitle: TextLiterals.OnboardingEnd.smallTitle)
            Spacer()
            ButtonComponents(.big, title: TextLiterals.OnboardingEnd.buttonTitle, disabledCondition: false) {
                isOnboardingOn = false
            }
        }
    }
}

struct OnboardingEndView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingEndView()
    }
}
