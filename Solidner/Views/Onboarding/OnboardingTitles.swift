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
    let centerSmallTitleTopPadding = CGFloat(10)
    var alignmentCase = AlignmentCase.leading
    var bigTitle = ""
    var smallTitle = ""
    var isSmallTitleExist = true
    var body: some View {
        switch alignmentCase {
        case .leading :
            leadingTitles()
        case .center :
            centerTitles()
        }
    }
    
    private func leadingTitles () -> some View {
        return HStack {
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
    private func centerTitles () -> some View {
        return VStack(spacing: 0) {
            Text(bigTitle)
                .font(.system(size: bigTitleFontSize, weight: .bold))
                .foregroundColor(bigTitleColor)
                .multilineTextAlignment(.center)
            Text(smallTitle)
                .font(.system(size: smallTitleFontSize, weight: .medium))
                .foregroundColor(smallTitleColor)
                .padding(.top, centerSmallTitleTopPadding)
                .multilineTextAlignment(.center)
        }
        .padding(.leading, leadingPadding)
    }
    enum AlignmentCase {
        case center
        case leading
    }
}

struct OnboardingTitles_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingTitles()
    }
}
