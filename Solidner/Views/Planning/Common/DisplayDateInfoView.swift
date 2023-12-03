//
//  DisplayDateInfoView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct DisplayDateInfoView: View {
    @EnvironmentObject private var user: UserOB
    let from: Date
    let to: Date

    private enum K {
        static var textColor: Color { .quarternaryText }
    }

    private var fromDateCount: Int {
        switch user.displayDateType {
        case .birth:
            return Date.diffDate(from: user.babyBirthDate, to: from)
//            Date.componentsBetweenDates(from: user.babyBirthDate, to: from).day!
        case .solid:
            return Date.diffDate(from: user.solidStartDate, to: from)
//            Date.componentsBetweenDates(from: user.solidStartDate, to: from).day!
        }
    }

    private var toDateCount: Int {
        switch user.displayDateType {
        case .birth:
            return Date.diffDate(from: user.babyBirthDate, to: to)
//            Date.componentsBetweenDates(from: user.babyBirthDate, to: to).day!
        case .solid:
            return Date.diffDate(from: user.solidStartDate, to: to)
//            Date.componentsBetweenDates(from: user.solidStartDate, to: to).day!
        }
    }

    var body: some View {
        HStack {
            Image(systemName: user.displayDateType.iconImageName)
                .clickableSFSymbolFont2()
            Text(TextLiterals.DailyPlanList.fromDateToDateText(from: fromDateCount, to: toDateCount))
                .clickableTextFont2()
        }
        .foregroundStyle(K.textColor)
    }
}

struct DisplayDateInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayDateInfoView(
            from: Date().add(.day, value: -3),
            to: Date()
        )
            .environmentObject(UserOB())
    }
}
