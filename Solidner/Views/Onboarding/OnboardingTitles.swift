//
//  OnboardingTitles.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct OnboardingTitles: View {
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
                    .foregroundColor(Color.bigTitleColor)
                if isSmallTitleExist {
                    Text(smallTitle)
                        .font(.system(size: smallTitleFontSize, weight: .medium))
                        .foregroundColor(Color.smallTitleColor)
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
                .foregroundColor(Color.bigTitleColor)
                .multilineTextAlignment(.center)
            Text(smallTitle)
                .font(.system(size: smallTitleFontSize, weight: .medium))
                .foregroundColor(Color.smallTitleColor)
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
