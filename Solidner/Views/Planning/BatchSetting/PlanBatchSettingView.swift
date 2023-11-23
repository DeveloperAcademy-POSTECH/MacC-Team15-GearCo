//
//  PlanBatchSettingView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

// TODO: - 패딩 ㄱㄱ

import SwiftUI

struct PlanBatchSettingView: View {
    @EnvironmentObject private var user: UserOB
    private enum K {
        static var rootVStackSpacing: CGFloat { 40 }
        static var titleColor: Color { .defaultText }
        static var hintColor: Color { .defaultText.opacity(0.4) }
        static var titleHintSpacing: CGFloat { 14 }

        static var displayDateTypeTopPadding: CGFloat { -7 }
        static var deleteWholeCalendarButtonTextColor: Color { .defaultText.opacity(0.8) }
    }
    private let texts = TextLiterals.PlanBatchSetting.self

    var body: some View {
        VStack(alignment: .leading, spacing: K.rootVStackSpacing) {
            settingTitle
            solidCycleGapSelectionView
            ThickDivider()
            solidDisplayDateTypeSelectionView
                .padding(.top, K.displayDateTypeTopPadding)
            Spacer()
            deleteWholeCalendarView
        }
    }

    private var settingTitle: some View {
        TitleAndHintView(
            title: texts.labelText,
            titleColor: K.titleColor,
            hint: texts.hintText,
            hintColor: K.hintColor,
            spacing: K.titleHintSpacing
        )
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
                .headerFont4()
                .foregroundStyle(K.deleteWholeCalendarButtonTextColor)
            Spacer()
            ButtonComponents(.tiny,
                             title: texts.deleteAllCalendarsButtonText) {
                print(#function)
            }
        }
    }
}

struct PlanBatchSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBatchSettingView().environmentObject(UserOB())
    }
}
