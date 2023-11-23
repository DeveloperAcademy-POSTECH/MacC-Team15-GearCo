//
//  Image+.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/15.
//

import SwiftUI

extension Image {
    enum ImageAssetName: String {
        case checkOn
        case checkOff
        case loginBackground
        case loginTypo
        case loginBg
        case tinyChevron
        case headerChevron
        case soCuteNameBackground
        case appsymbol
    }
    
    init(assetName: ImageAssetName){
        self.init(assetName.rawValue)
    }
}

extension Image {
    func clickableSFSymbolFont2() -> some View {
        self.font(.system(size: 13, weight: .medium))
    }
}
