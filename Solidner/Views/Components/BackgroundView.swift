//
//  BackgroundView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/23.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Color.secondBgColor.ignoresSafeArea()
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
