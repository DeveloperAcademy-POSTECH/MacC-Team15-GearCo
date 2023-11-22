//
//  PlanBatchSettingView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct PlanBatchSettingView: View {
    private let texts = TextLiterals.PlanBatchSetting.self

    var body: some View {
        VStack(alignment: .leading) {
            settingTitle
            ThickDivider()
        }
    }

    private var settingTitle: some View {
        TitleAndHintView(title: texts.labelText, hint: texts.hintText)
    }
}

struct PlanBatchSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBatchSettingView()
    }
}
