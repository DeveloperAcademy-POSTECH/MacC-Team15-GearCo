//
//  UserOB.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI

class userData: ObservableObject {
    @AppStorage("AppleID") var AppleID = ""
    @AppStorage("nickName") var nickName = ""
}
