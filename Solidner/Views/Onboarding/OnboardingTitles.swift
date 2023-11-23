//
//  OnboardingTitles.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

struct OnboardingTitles: View {
    private let leadingPadding = 4.0
    private let bigTitleFontSize = 28.0
    private let smallTitleFontSize = 19.0
    private let smallTitleTopPadding = 22.0
    private let centerSmallTitleTopPadding = 16.0
    var alignmentCase = AlignmentCase.leading
    let bigTitle: String
    var smallTitle: String
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
            VStack(alignment: .leading, spacing: 0) {
                Text(bigTitle)
                    .headerFont1()
                    .foregroundColor(.defaultText)
                if isSmallTitleExist {
                    Text(smallTitle)
                        .bodyFont1()
                        .foregroundColor(.defaultText.opacity(0.6))
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
                .headerFont1()
                .foregroundColor(.defaultText)
                .multilineTextAlignment(.center)
            Text(smallTitle)
                .bodyFont1()
                .foregroundColor(.defaultText.opacity(0.6))
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
        OnboardingTitles(bigTitle: "서비스 이용약관에\n동의해주세요", smallTitle: "솔리너의 원활한 사용을 위해\n아래의 정보 제공에 동의해주세요")
    }
}
