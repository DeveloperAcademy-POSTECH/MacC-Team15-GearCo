//
//  BackButtonHeaderView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/11.
//

import SwiftUI

struct BackButtonHeader: View {
    private let backButtonSymbolWidth: CGFloat = 10
    private let backButtonSymbolHeight: CGFloat = 17.5
    private let backButtonHorizontalPadding: CGFloat = 16
    private let backButtonTopPadding: CGFloat = 18
    var action: ()->Void = {}
    var title: String = ""
    
    var body: some View {
        headerButton(action: action)
    }
    
    func headerButton(action: @escaping ()-> Void) -> some View {
        return HStack(spacing: 0) {
            Button(action: action, label: {
                Image(assetName: .headerChevron)
            })
            Spacer()
        }
        //.frame(height: 54)
        .overlay {
            Text(title)
                .headerFont5()
                .foregroundColor(.defaultText)
        }
        .padding(.horizontal, backButtonHorizontalPadding)
        .padding(.top, backButtonTopPadding)
    }
}

struct BackButtonHeader_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonHeader()
    }
}
