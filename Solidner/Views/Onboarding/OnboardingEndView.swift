//
//  OnboardingEndView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct OnboardingEndView: View {
    var body: some View {
        viewBody()
    }
    func viewBody() -> some View {
        return VStack(spacing: 0) {
            Spacer()
            OnboardingTitles(alignmentCase: .center, bigTitle: TextLiterals.OnboardingEnd.bigTitle, smallTitle: TextLiterals.OnboardingEnd.smallTitle)
            Spacer()
            ButtonComponents().bigButton(title: TextLiterals.OnboardingEnd.buttonTitle, disabledCondition: false, action: {})
        }
    }
}

struct OnboardingEndView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingEndView()
    }
}
