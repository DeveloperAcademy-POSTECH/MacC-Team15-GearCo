//
//  TitleAndActionButtonView.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct TitleAndActionButtonView: View {
    let title: String
    let buttonLabel: String
    let buttonAction: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.title3).fontWeight(.semibold)
            Spacer()
            Button(action: buttonAction) {
                Text(buttonLabel)
            }
        }
        .padding(.vertical)
    }
}
