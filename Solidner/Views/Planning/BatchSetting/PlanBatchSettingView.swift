//
//  PlanBatchSettingView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct PlanBatchSettingView: View {
    @EnvironmentObject var user: UserOB

    private let texts = TextLiterals.PlanBatchSetting.self

    var body: some View {
        VStack(alignment: .leading) {
            settingTitle
            solidCycleGapSelectionView
            ThickDivider()
            solidDisplayDateTypeSelectionView
            Spacer()
            deleteWholeCalendarView
        }
    }

    private var settingTitle: some View {
        TitleAndHintView(title: texts.labelText, hint: texts.hintText)
    }

    private var solidCycleGapSelectionView: some View {
        SolidnerSegmentedCyclePicker(user: user)
    }

    private var solidDisplayDateTypeSelectionView: some View {
        SolidnerSegmentedDisplayDateTypePicker(user: user)
    }

    private var deleteWholeCalendarView: some View {
        HStack {
            Text(texts.deleteAllCalendarsText)
            Spacer()
            Button {
                print(#function)
            } label: {
                Text(texts.deleteAllCalendarsButtonText)
            }
        }
    }
}

struct PlanBatchSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBatchSettingView().environmentObject(UserOB())
    }
}
