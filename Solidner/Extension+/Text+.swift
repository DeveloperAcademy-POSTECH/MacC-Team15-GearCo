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

extension Text {
    func foreground(color: Color) -> Text {
        if #available(iOS 17.0, *) {
            return self.foregroundStyle(color)
        } else {
            return self.foregroundColor(color)
        }
    }
}

extension Text {
    enum HeaderFontType {
        case one, two, three, four, five, six
    }

    func headerFont(_ type: HeaderFontType) -> some View {
        switch type {
        case .one:
            return AnyView(self.headerFont1())
        case .two:
            return AnyView(self.headerFont2())
        case .three:
            return AnyView(self.headerFont3())
        case .four:
            return AnyView(self.headerFont4())
        case .five:
            return AnyView(self.headerFont5())
        case .six:
            return AnyView(self.headerFont6())
        }
    }
}
//
extension Text {
    enum CustomFontType {
        case header1, header2, header3, header4, header5, header6
        case body1, body2, body3
        case button
        case clickableText1, clickableText2
        case toast
        case inputError
        case tag
        case dayDisplay1, dayDisplay2
        case weekDisplay1, weekDisplay2, weekDisplay3
    }

    func customFont(_ type: CustomFontType?, color: Color? = nil) -> some View {
        if let type {
            let returnText: some View = {
                switch type {
                case .header1:
                    return AnyView(headerFont1())
                case .header2:
                    return AnyView(headerFont2())
                case .header3:
                    return AnyView(headerFont3())
                case .header4:
                    return AnyView(headerFont4())
                case .header5:
                    return AnyView(headerFont5())
                case .header6:
                    return AnyView(headerFont6())
                case .body1:
                    return AnyView(bodyFont1())
                case .body2:
                    return AnyView(bodyFont2())
                case .body3:
                    return AnyView(bodyFont3())
                case .button:
                    return AnyView(buttonFont())
                case .clickableText1:
                    return AnyView(clickableTextFont1())
                case .clickableText2:
                    return AnyView(clickableTextFont2())
                case .toast:
                    return AnyView(toastFont())
                case .inputError:
                    return AnyView(inputErrorFont())
                case .tag:
                    return AnyView(tagFont())
                case .dayDisplay1:
                    return AnyView(dayDisplayFont1())
                case .dayDisplay2:
                    return AnyView(dayDisplayFont2())
                case .weekDisplay1:
                    return AnyView(weekDisplayFont1())
                case .weekDisplay2:
                    return AnyView(weekDisplayFont2())
                case .weekDisplay3:
                    return AnyView(weekDisplayFont3())
                }
            }()
            if let color {
                return AnyView(returnText.foregroundStyle(color))
            } else {
                return AnyView(returnText)
            }
        } else {
            return AnyView(self)
        }
    }
}
