//
//  TitleAndHintView.swift
//  Solidner
//
//  Created by sei on 11/16/23.
//

import SwiftUI

struct TitleAndHintView: View {
    let title: String
    let hint: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title).bold()
            Text(hint)
                .font(.body)
                .foregroundStyle(.gray)
        }
        .padding(.vertical)
    }
}
