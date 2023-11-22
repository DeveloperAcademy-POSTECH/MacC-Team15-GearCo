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
        }
    }

    private var settingTitle: some View {
        TitleAndHintView(title: texts.labelText, hint: texts.hintText)
    }

    private var solidCycleGapSelectionView: some View {
        SolidnerSegmentedCyclePicker(user: user)
    }
}

struct PlanBatchSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBatchSettingView().environmentObject(UserOB())
    }
}
