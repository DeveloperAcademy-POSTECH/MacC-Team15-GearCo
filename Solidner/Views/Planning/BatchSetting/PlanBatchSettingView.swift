//
//  PlanBatchSettingView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

// TODO: - 패딩 ㄱㄱ

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
        // TODO: - 삭제 버튼 컴포넌트로 변경하기
        HStack {
            Text(texts.deleteAllCalendarsText)
            Spacer()
            Button {
                // TODO: - 캘린더 삭제 구현하기
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
