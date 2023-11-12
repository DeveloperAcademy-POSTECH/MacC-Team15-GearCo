//
//  OnboardingTitles.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct OnboardingTitles: View {
    let bigTitleColor = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1))
    let smallTitleColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.6)
    let leadingPadding = CGFloat(4)
    let bigTitleFontSize = CGFloat(28)
    let smallTitleFontSize = CGFloat(19)
    let smallTitleTopPadding = CGFloat(16)
    @State var bigTitle: String = "언제부터 이유식을\n계획할까요?"
    @State var smallTitle: String = "이미 이유식을 진행 중이라면\n처음 시작하신 날짜를 알려주세요"
    @State var isSmallTitleExist = true
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bigTitle)
                    .font(.system(size: bigTitleFontSize, weight: .bold))
                    .foregroundColor(bigTitleColor)
                if isSmallTitleExist {
                    Text(smallTitle)
                        .font(.system(size: smallTitleFontSize, weight: .medium))
                        .foregroundColor(smallTitleColor)
                        .padding(.top, smallTitleTopPadding)
                }
            }
            .padding(.leading, leadingPadding)
            Spacer()
        }
    }
}

struct OnboardingTitles_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitles()
    }
}
