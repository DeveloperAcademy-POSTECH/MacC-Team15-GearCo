//
//  Color+.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/15.
//

import SwiftUI

extension Color {
    static let buttonDisabledColor = Color(#colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1)) //DEDEDE
    static let buttonDisabledTextColor = Color(#colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)) //4A4A4A
    static let buttonDefaultColor = Color.blue
    static let buttonDefaultTextColor = Color.white
    static let backButtonColor = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1)).opacity(0.4) //151515
    static let textFieldColor = Color(#colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)) //EDEDED
    static let warningMessageColor = Color(#colorLiteral(red: 0.9176470588, green: 0.4352941176, blue: 0.4196078431, alpha: 1)) //EA6F6B
    static let bigTitleColor = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1))
    static let smallTitleColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.6)
    static let soCuteBgColor = Color(#colorLiteral(red: 0.8588235294, green: 0.9098039216, blue: 0.9568627451, alpha: 1))
    //ingredient
    static let yellowVegitable = Color(#colorLiteral(red: 0.9019607843, green: 0.8039215686, blue: 0.5450980392, alpha: 1)) //E97A82
    static let greenVegitable = Color(#colorLiteral(red: 0.8117647059, green: 0.8588235294, blue: 0.6509803922, alpha: 1)) //CFDBA6
    static let etcVegitable = Color(#colorLiteral(red: 0.8078431373, green: 0.8196078431, blue: 0.737254902, alpha: 1)) //CED1BC
    static let grain = Color(#colorLiteral(red: 0.8549019608, green: 0.7843137255, blue: 0.6156862745, alpha: 1)) //DAC89D
    static let dairy = Color(#colorLiteral(red: 0.7921568627, green: 0.8588235294, blue: 0.9568627451, alpha: 1)) //CADBF4
    static let fruit = Color(#colorLiteral(red: 0.8666666667, green: 0.7803921569, blue: 0.9764705882, alpha: 1)) //DDC7F9
    static let fishAndMeat = Color(#colorLiteral(red: 0.9215686275, green: 0.6980392157, blue: 0.6352941176, alpha: 1)) //EBB2A2
    static let etcIngredient = Color(#colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)) //CBCBCB
    //component
    static let accentColor1 = Color(#colorLiteral(red: 0.9137254902, green: 0.4784313725, blue: 0.5098039216, alpha: 1)) //E97A82
    static let accentColor2 = Color(#colorLiteral(red: 0.4, green: 0.2823529412, blue: 0.1725490196, alpha: 1)) //66482C
    static let bgColor = Color(#colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.7960784314, alpha: 1)) //F7F6F4
    static let secondBgColor = Color(#colorLiteral(red: 0.968627451, green: 0.9529411765, blue: 0.9254901961, alpha: 1)) //F7F3EC
    static let buttonBgColor = Color(#colorLiteral(red: 0.9137254902, green: 0.8941176471, blue: 0.862745098, alpha: 1)) //E9E4DC
    static let dividerColor = Color(#colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)) //D9D9D9
    static let chipBgColor = Color(#colorLiteral(red: 0.9098039216, green: 0.8941176471, blue: 0.8823529412, alpha: 1)) //E8E4E1
    static let buttonStrokeColor = Color.defaultText.opacity(0.1)
    static let listStrokeColor = Color(#colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)) //EAEAEA
    static let ageColor = Color(#colorLiteral(red: 0.6588235294, green: 0.4705882353, blue: 0.7450980392, alpha: 1)) //A878BE
    static let newColor = Color(#colorLiteral(red: 0.4352941176, green: 0.6549019608, blue: 0.8549019608, alpha: 1)) //6FA7DA
    static let loginButtonColor = Color(#colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1))//222222
    static let primaryLabelColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.6) // 000000 * opacity 60
    static let placeHolderColor = Color(#colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1))
    //text
    static let defaultText = Color(#colorLiteral(red: 0.0834152922, green: 0.0834152922, blue: 0.0834152922, alpha: 1)) //111111
    static let defaultText_wh = Color.white
    static let primeText = Color(#colorLiteral(red: 0.2470588235, green: 0.2431372549, blue: 0.2431372549, alpha: 1)) //3F3E3E
    static let secondaryText = Color(#colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)) //4F4F4F
    static let tertinaryText = Color(#colorLiteral(red: 0.6117647059, green: 0.6117647059, blue: 0.6117647059, alpha: 1)) //9C9C9C
    static let quarternaryText = Color(#colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)) //C8C8C8
    static let mainBackgroundColor = Color(#colorLiteral(red: 0.968627451, green: 0.9529411765, blue: 0.9254901961, alpha: 1)) //F7F3EC
    static let underLineText = Color(#colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)) //D9D9D9
}
