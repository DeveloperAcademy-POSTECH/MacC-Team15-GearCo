//
//  Text+.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/22.
//

import SwiftUI

extension Text {
    func headerFont1() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 28))
            .lineSpacing(7)
    }
    func headerFont2() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 26))
            .lineSpacing(6)
    }
    func headerFont3() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 26))
    }
    func headerFont4() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 19))
            .lineSpacing(5)
    }
    func headerFont5() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 17))
            .lineSpacing(10)
    }
    func headerFont6() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 15))
    }
    func bodyFont1() -> some View {
        self.font(.custom(FontWeightCase.medium.rawValue, size: 17))
            .lineSpacing(6)
    }
    func bodyFont2() -> some View {
        self.font(.custom(FontWeightCase.medium.rawValue, size: 15))
            .lineSpacing(7)
    }
    func bodyFont3() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 13))
            .lineSpacing(5)
    }
    func buttonFont() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 18))
            .lineSpacing(5)
    }
    func clickableTextFont1() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 15))
    }
    func clickableTextFont2() -> some View {
        self.font(.custom(FontWeightCase.medium.rawValue, size: 13))
    }
    func toastFont() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 14))
            .tracking(-0.14)
    }
    func inputErrorFont() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 11.5))
    }
    func tagFont() -> some View {
        self.font(.custom(FontWeightCase.bold.rawValue, size: 11))
    }
    func dayDisplayFont1() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 18))
    }
    func dayDisplayFont2() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 17))
    }
    func weekDisplayFont1() -> some View {
        self.font(.custom(FontWeightCase.medium.rawValue, size: 11))
    }
    func weekDisplayFont2() -> some View {
        self.font(.custom(FontWeightCase.medium.rawValue, size: 10))
    }
    func weekDisplayFont3() -> some View {
        self.font(.custom(FontWeightCase.semiBold.rawValue, size: 10))
    }
    enum FontWeightCase: String {
        case medium = "Pretendard-Medium"
        case bold = "Pretendard-Bold"
        case semiBold = "Pretendard-SemiBold"
    }
}
