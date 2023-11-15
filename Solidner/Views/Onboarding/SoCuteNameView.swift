//
//  SoCuteNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct SoCuteNameView: View {
    private let delaySecond = 0.7
    private let labelFontSize = 27.83
    private let cuteNameMessageTopPadding = 10.0
    @State private var isNicknameAppear = false
    @State private var isMessageAppear = false
    @State private var isButtonAppear = false
    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            Color.soCuteBgColor.ignoresSafeArea()
            labelView()
            buttonView()
        }
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
    }
    private func labelView() -> some View {
        return VStack(spacing: 0) {
            Text(user.babyName+",")
                .font(.system(size: labelFontSize, weight: .bold))
                .foregroundColor(isNicknameAppear ? .black : .clear)
            Text(TextLiterals.SoCuteName.cuteNameMessage)
                .font(.system(size: labelFontSize, weight: .bold))
                .foregroundColor(isMessageAppear ? .black : .clear)
                .padding(.top, cuteNameMessageTopPadding)
        }
    }
    private func buttonView() -> some View {
        return VStack {
            Spacer()
            if isButtonAppear {
                ButtonComponents().bigButton(disabledCondition: false, action: {}, buttonColor: Color.white, titleColor: Color.black)
                .transition(.opacity.animation(.easeIn))
            }
        }
    }
}

struct SoCuteNameView_Previews: PreviewProvider {
    static var previews: some View {
        SoCuteNameView().environmentObject(UserOB())
    }
}
