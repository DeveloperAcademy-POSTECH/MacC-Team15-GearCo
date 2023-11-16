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
    }
    
    init(_ name: ImageAssetName){
        self.init(name.rawValue)
    }
}
