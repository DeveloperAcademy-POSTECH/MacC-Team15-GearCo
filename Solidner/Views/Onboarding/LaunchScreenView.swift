//
//  LaunchScreenView.swift
//  Solidner
//
//  Created by 황지우2 on 12/1/23.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isLoading = false
    var body: some View {
        ZStack {
            BackgroundView()
            if isLoading {
                Image(.appsymbol)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1 , execute: {
                withAnimation { isLoading.toggle() }
            })
        }
    }
}

#Preview {
    LaunchScreenView()
}
