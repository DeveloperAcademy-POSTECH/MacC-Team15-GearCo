//
//  ToastMessage.swift
//  Solidner
//
//  Created by sei on 12/1/23.
//

import SwiftUI

struct ToastMessage: View {
    enum ToastMessageType {
        case warnMismatch, savePlan
    }
    
    let type: ToastMessageType
    
    var image: Image {
        switch type {
        case .warnMismatch:
            Image(systemName: "light.beacon.max.fill")
        case .savePlan:
            Image(assetName: .check)
        }
    }
    
    var message: String {
        switch type {
        case .warnMismatch:
            "방금 고른 재료는 지금 재료와 궁합이 좋지 않아요!"
        case .savePlan:
            "변경 완료! 캘린더에도 반영되었어요"
        }
    }
    
    var body: some View {
        HStack(spacing: 4.27) {
            image
                .foregroundStyle(Color.tertinaryText)
            Text(message)
                .customFont(.toast, color: .tertinaryText)
            Spacer()
        }
        .padding(.leading, 12.25)
        .frame(height: 48)
        .withRoundedBackground(
            cornerRadius: 12,
            fill: Color.defaultText_wh,
            strokeBorder: Color.listStrokeColor,
            lineWidth: 1
        )
    }
}

#Preview {
    Group {
        ToastMessage(type: .warnMismatch)
        ToastMessage(type: .savePlan)
    }
}
