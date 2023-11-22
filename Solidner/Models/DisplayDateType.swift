//
//  DisplayDateType.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

enum DisplayDateType: Int, CaseIterable, Hashable, CustomStringConvertible {
    case solid, birth

    var description: String {
        switch self {
        case .solid:
            return TextLiterals.PlanBatchSetting.bySolidDate
        case .birth:
            return TextLiterals.PlanBatchSetting.byBirthDate
        }
    }

    var iconImage: Image {
        switch self {
        case .solid:
            return Image(systemName: "fork.knife")
        case .birth:
            return Image(systemName: "heart.fill")
        }
    }

    func textInfo(of user: UserOB, from: Date, to: Date) -> some View {
        var fromDateCount: Int
        var toDateCount: Int

        switch self {
        case .solid:
            fromDateCount = Date.componentsBetweenDates(from: user.solidStartDate, to: from).day!
            toDateCount = Date.componentsBetweenDates(from: user.solidStartDate, to: to).day!
        case .birth:
            fromDateCount = Date.componentsBetweenDates(from: user.babyBirthDate, to: from).day!
            toDateCount = Date.componentsBetweenDates(from: user.babyBirthDate, to: to).day!
        }

        return HStack {
            iconImage
            Text(TextLiterals.DailyPlanList.fromDateToDateText(from: fromDateCount, to: toDateCount))
        }
    }
}
