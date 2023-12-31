//
//  AgreeToTermsView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/15.
//

import SwiftUI

struct AgreeToTermsView: View {
    private let termsButtonsSpacing = 16.0
    private let bigButtonTopPadding = 70.0
    private let agreeTitleLeadingPadding = 15.0
    @State private var isAgreeToServiceUse = true
    @State private var isAgreeToPersonalInfo = true
    @State private var isAgreeToAdvertising = true
    @State private var openServiceUseTerms = false
    @State private var openPersonalInfoTerms = false
    @State private var openAdvertisingTerms = false
    @State private var navigationIsPresented = false
//    @EnvironmentObject var user: UserOB
    @State var tempUserInfo: TempUserInfo = TempUserInfo()
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                OnboardingTitles(bigTitle: TextLiterals.AgreeToTerms.bigTitle, smallTitle: TextLiterals.AgreeToTerms.smallTitle)
                Spacer()
                VStack(spacing: termsButtonsSpacing) {
                    agreeButton(agreeCase: .serviceUse)
                    agreeButton(agreeCase: .personalInfo)
                    agreeButton(agreeCase: .advertising)
                }
                ButtonComponents(.big, disabledCondition: disabledCondition, action: {
                    tempUserInfo.isAgreeToAdvertising = isAgreeToAdvertising
                    navigationIsPresented = true
                })
                .padding(.top, bigButtonTopPadding)
            }
            .padding(horizontal: 20, top: 76, bottom: 20)
        }
        .navigationDestination(isPresented: $navigationIsPresented) {
            NickNameView(nickNameViewCase: .userName, tempUserInfo: $tempUserInfo)
        }
        .sheet(isPresented: $openServiceUseTerms) {
            TermsWebView(agreeCase: .serviceUse)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openPersonalInfoTerms) {
            TermsWebView(agreeCase: .personalInfo)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $openAdvertisingTerms) {
            TermsWebView(agreeCase: .advertising)
                .presentationDragIndicator(.visible)
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
                return TextLiterals.AgreeToTerms.serviceUseTitle
            case .personalInfo :
                return TextLiterals.AgreeToTerms.personalInfoTitle
            case .advertising :
                return TextLiterals.AgreeToTerms.advertisingTitle
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
                        isAgreeToServiceUse ? Image(assetName: .checkOn) : Image(assetName: .checkOff)
                    case .personalInfo :
                        isAgreeToPersonalInfo ? Image(assetName: .checkOn) : Image(assetName: .checkOff)
                    case .advertising :
                        isAgreeToAdvertising ? Image(assetName: .checkOn) : Image(assetName: .checkOff)
                    }
                    Text(title)
                        .foregroundColor(.primaryLabelColor)
                        .clickableTextFont1()
                        .padding(.leading, agreeTitleLeadingPadding)
                }
            }
            Spacer()
            Button(action: {
                switch agreeCase {
                case .serviceUse :
                    openServiceUseTerms = true
                case .personalInfo :
                    openPersonalInfoTerms = true
                case .advertising :
                    openAdvertisingTerms = true
                }
            }){
                Image(assetName: .tinyChevron)
                    .foregroundColor(.black.opacity(0.4))
            }
        }
    }
}

struct AgreeToTermsView_Previews: PreviewProvider {
    static var previews: some View {
        AgreeToTermsView().environmentObject(UserOB())
    }
}
