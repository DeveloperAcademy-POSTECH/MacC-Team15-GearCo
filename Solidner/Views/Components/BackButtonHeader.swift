//
//  BackButtonHeaderView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/11.
//

import SwiftUI

struct BackButtonHeader: View {
    let backButtonColor = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1)).opacity(0.4)
    let backButtonFrameSize: CGFloat = 34
    let backButtonSymbolWidth: CGFloat = 8.5
    let backButtonSymbolHeight: CGFloat = 17
    let backButtonHorizontalPadding: CGFloat = 16.64
    let backButtonTopPadding: CGFloat = 6.73
    let backButtonSystemName = "chevron.left"
    @State var action: ()->Void = {}
    
    var body: some View {
        headerButton(action: action)
    }
    
    func headerButton(action: @escaping ()-> Void) -> some View {
        return HStack {
            Button(action: action, label: {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: backButtonFrameSize, height: backButtonFrameSize)
                    .overlay {
                        Image(systemName: backButtonSystemName)
                            .resizable()
                            .frame(width: backButtonSymbolWidth, height: backButtonSymbolHeight)
                            .foregroundColor(backButtonColor)
                    }
            })
            Spacer()
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
