//
//  ToastMessage.swift
//  Solidner
//
//  Created by sei on 12/1/23.
//

import SwiftUI

struct ToastMessage: View {
    @Binding var isPresented: Bool
    let image: ImageResource
    let message: String
    
    var body: some View {
        HStack(spacing: 4.27) {
            Image(image)
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

extension ToastMessage {
    init(_ isPresented: Binding<Bool>, image: ImageResource, message: String) {
        self._isPresented = isPresented
        self.image = image
        self.message = message
    }
}

#Preview {
    ToastMessage(.constant(true), image: .checkOff, message: "하하")
}
