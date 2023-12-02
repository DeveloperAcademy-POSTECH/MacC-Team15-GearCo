//
//  SoCuteNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct SoCuteNameView: View {
    private let delaySecond = 0.7
    private let cuteNameMessageTopPadding = 9.0
    @State private var isNicknameAppear = false
    @State private var isMessageAppear = false
    @State private var isButtonAppear = false
    @State private var navigationIsPresented = false
    @Binding var tempUserInfo: TempUserInfo
//    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            labelView()
            buttonView()
                .padding(top: 0, leading: 20, bottom: 20, trailing: 20)
        }
        .background(
            Image(assetName: .soCuteNameBackground)
                .resizable()
                .frame(width: UIScreen.getWidth(390))
                .ignoresSafeArea()
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation(.easeInOut.delay(delaySecond)) {
                    self.isNicknameAppear.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+delaySecond) {
                withAnimation(Animation.default.delay(delaySecond)) {
                    self.isMessageAppear.toggle()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3*delaySecond) {
                withAnimation(.easeInOut.delay(delaySecond)) {
                    self.isButtonAppear.toggle()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigationIsPresented){
            BabyBirthDateView(tempUserInfo: $tempUserInfo)
        }
    }
    private func labelView() -> some View {
        return VStack(spacing: 0) {
            Text(tempUserInfo.babyName+",")
                .headerFont1()
                .foregroundColor(isNicknameAppear ? .secondBgColor : .clear)
            Text(TextLiterals.SoCuteName.cuteNameMessage)
                .headerFont1()
                .foregroundColor(isMessageAppear ? .secondBgColor : .clear)
                .padding(.top, cuteNameMessageTopPadding)
        }
    }
    private func buttonView() -> some View {
        return VStack {
            Spacer()
            if isButtonAppear {
                ButtonComponents().bigButton(title: TextLiterals.SoCuteName.cuteNameButtonTitle, disabledCondition: false, action: {
                    navigationIsPresented = true
                }, buttonColor: .defaultText_wh, titleColor: .defaultText)
                .transition(.opacity.animation(.easeIn))
            }
        }
    }
}
