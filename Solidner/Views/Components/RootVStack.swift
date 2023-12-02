//
//  RootVStack.swift
//  Solidner
//
//  Created by sei on 11/27/23.
//

import SwiftUI

struct RootVStack<C: View>: View {
    @ViewBuilder let content: C
    
    var body: some View {
        VStack(spacing: .zero) {
            content
        }
        .navigationBarBackButtonHidden()
        .withClearBackground(color: .secondBgColor)
    }
}


struct RootDefaultSpacingVStack<C: View>: View {
    @ViewBuilder let content: C
    
    var body: some View {
        VStack(spacing: 19.88) {
            content
        }
        .navigationBarBackButtonHidden()
        .withClearBackground(color: .secondBgColor)
    }
}

#Preview {
    RootVStack {
        Text("haha")
    }
}
