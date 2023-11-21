//
//  AddTestIngredientsView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

struct AddTestIngredientsView: View {
    private let Texts = TextLiterals.AddIngredientsView.self
    
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader(title: Texts.testViewTitle)
            Spacer()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                }
            }
        }.background(Color.mainBackgroundColor)
    }
}

struct AddTestIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTestIngredientsView()
    }
}
