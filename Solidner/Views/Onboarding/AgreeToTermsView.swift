//
//  AgreeToTermsView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/15.
//

import SwiftUI

struct AgreeToTermsView: View {
    let termsButtonsSpacing = 16.0
    let bigButtonTopPadding = 16.0
    let agreeTitleLeadingPadding = 15.0
    @State private var isAgreeToServiceUse = true
    @State private var isAgreeToPersonalInfo = true
    @State private var isAgreeToAdvertising = true
    @EnvironmentObject var user: UserOB
    var body: some View {
        VStack(spacing: 0) {
            OnboardingTitles(bigTitle: TextLiterals.AgreeToTermsView.bigTitle, smallTitle: TextLiterals.AgreeToTermsView.smallTitle)
            Spacer()
            VStack(spacing: termsButtonsSpacing) {
                agreeButton(agreeCase: .serviceUse)
                agreeButton(agreeCase: .personalInfo)
                agreeButton(agreeCase: .advertising)
            }
            ButtonComponents().bigButton(disabledCondition: disabledCondition, action: {
                user.isAgreeToAdvertising = isAgreeToAdvertising
            })
            .padding(.top, bigButtonTopPadding)
        }
    }
    private var disabledCondition: Bool {
        if isAgreeToServiceUse && isAgreeToPersonalInfo {
            return false
        } else {
            return true
        }
    }
    private func agreeButton(agreeCase: AgreeCase) -> some View {
        var title: String {
            switch agreeCase {
            case .serviceUse :
                return TextLiterals.AgreeToTermsView.serviceUseTitle
            case .personalInfo :
                return TextLiterals.AgreeToTermsView.personalInfoTitle
            case .advertising :
                return TextLiterals.AgreeToTermsView.advertisingTitle
            }
        }
        return HStack {
            Button(action: {
                withAnimation {
                    switch agreeCase {
                    case .serviceUse :
                        isAgreeToServiceUse.toggle()
                    case .personalInfo :
                        isAgreeToPersonalInfo.toggle()
                    case .advertising :
                        isAgreeToAdvertising.toggle()
                    }
                }
            }){
                HStack(spacing: 0) {
                    switch agreeCase {
                    case .serviceUse :
                        isAgreeToServiceUse ? Image(.checkOn) : Image(.checkOff)
                    case .personalInfo :
                        isAgreeToPersonalInfo ? Image(.checkOn) : Image(.checkOff)
                    case .advertising :
                        isAgreeToAdvertising ? Image(.checkOn) : Image(.checkOff)
                    }
                    Text(title)
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.leading, agreeTitleLeadingPadding)
                }
            }
            Spacer()
            Button(action: {
                
            }){
                Image(systemName: "chevron.right")
                    .foregroundColor(.black.opacity(0.4))
            }
        }
    }
    enum AgreeCase {
        case serviceUse
        case personalInfo
        case advertising
    }
}

struct AgreeToTermsView_Previews: PreviewProvider {
    static var previews: some View {
        AgreeToTermsView()
    }
}
