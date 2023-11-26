//
//  Divider.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/24.
//

import SwiftUI

struct ViewDivider: View {
    private var foregroundColor: Color {
        switch dividerCase {
        case .thick:
            return .dividerColor.opacity(0.2)
        case .thin:
            return .quarternaryText
        }
    }
    private var height: CGFloat {
        switch dividerCase {
        case .thick:
            return 10
        case .thin:
            return 1
        }
    }
    private var horizontalPadding: CGFloat {
        switch dividerCase {
        case .thick:
            return -20
        case .thin:
            return 0
        }
    }
    let dividerCase: DividerCase
    enum DividerCase {
        case thin
        case thick
    }
    var body: some View {
        Rectangle()
            .foregroundStyle(foregroundColor)
            .frame(height: height)
            .padding(.horizontal, horizontalPadding)
    }
}

struct ViewDivider_Previews: PreviewProvider {
    static var previews: some View {
        ViewDivider(dividerCase: .thin)
    }
}
