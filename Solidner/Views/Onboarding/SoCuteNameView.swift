//
//  SoCuteNameView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct SoCuteNameView: View {
    let backgroundColor = Color(#colorLiteral(red: 0.8588235294, green: 0.9098039216, blue: 0.9568627451, alpha: 1))
    let delaySecond = 0.7
    let labelFontSize = 27.83
    let cuteNameMessageTopPadding = 10.0
    @State private var isNicknameAppear = false
    @State private var isMessageAppear = false
    @State private var isButtonAppear = false
    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea()
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
