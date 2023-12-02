//
//  PlanEmptyView.swift
//  Solidner
//
//  Created by sei on 12/1/23.
//

import SwiftUI

struct PlanEmptyView: View {
    @State private var wantsToReset: Bool = false
    
    var body: some View {
        ZStack {
            backVStack
            frontVStack
        }
    }
    
    private var backVStack: some View {
        VStack(spacing: 12) {
            Spacer()
            motifImage
            textView
            Spacer()
        }
    }
    
    private var frontVStack: some View {
        VStack {
            Spacer()
            navigateToReset
        }
    }
    
    private var motifImage: some View {
        VStack {
            Image(.solidnerMotif)
                .blendMode(.luminosity)
                .opacity(0.8)
        }
    }
    
    private var textView: some View {
        Text("해당 날짜에는\n아직 이유식 계획이 없어요")
            .customFont(.body1, color: .quarternaryText)
            .multilineTextAlignment(.center)
    }
    
    private var navigateToReset: some View {
        Button {
            wantsToReset = true
            //TODO: - "플랜 세팅 후 메인 화면으로 가야 합니다.")
            // navigation path 날려~
        } label: {
            Text("캘린더 초기화를 찾으시나요?")
                .customFont(.clickableText2, color: .primary.opacity(0.3))
                .underline()
        }
        .padding(.bottom, 20)
        .navigationDestination(isPresented: $wantsToReset) {
            // 전체 설정 뷰~
            PlanBatchSettingView()
        }
    }
}

#Preview {
    PlanEmptyView()
}
