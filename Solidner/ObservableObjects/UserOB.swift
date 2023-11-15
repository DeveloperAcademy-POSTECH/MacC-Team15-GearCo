//
//  UserOB.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI

class UserOB: ObservableObject {
    @AppStorage("AppleID") var AppleID = ""
    @AppStorage("email") var email = ""
    @AppStorage("nickName") var nickName = ""
    @AppStorage("babyName") var babyName = ""
    @AppStorage("isAgreeToAdvertising") var isAgreeToAdvertising = true
    @AppStorage("babyBirthDate") var babyBirthDate = Date()
    @AppStorage("solidStartDate") var solidStartDate = Date()
}
