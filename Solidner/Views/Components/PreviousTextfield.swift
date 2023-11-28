//
//  PreviousTextfield.swift
//  Solidner
//
//  Created by 황지우2 on 11/28/23.
//

import SwiftUI

struct PreviousTextfield: View {
        @State var value = ""
        @State var open = false
        @FocusState var isFocused: Bool
        
        var body: some View {
            Button("옵흔") {
                open = true
            }
            .sheet(isPresented: $open) {
                ReportIngredientModalView().environmentObject(UserOB())
            }
        }
}

#Preview {
    PreviousTextfield()
}
