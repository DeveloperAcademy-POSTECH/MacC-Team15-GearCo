//
//  UserOB.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI

final class UserOB: ObservableObject {
    @AppStorage("AppleID") var AppleID = ""
    @AppStorage("email") var email = ""
    @AppStorage("nickName") var nickName = ""
    @AppStorage("babyName") var babyName = ""
    @AppStorage("isAgreeToAdvertising") var isAgreeToAdvertising = true
    @AppStorage("babyBirthDate") var babyBirthDate = Date.date(year: 2023, month: 2, day: 22)!
    @AppStorage("solidStartDate") var solidStartDate = Date.date(year: 2023, month: 9, day: 22)!
    @AppStorage("planCycleGap") var planCycleGap = CycleGaps.three
    @AppStorage("displayDateType") var displayDateType = DisplayDateType.birth
}
