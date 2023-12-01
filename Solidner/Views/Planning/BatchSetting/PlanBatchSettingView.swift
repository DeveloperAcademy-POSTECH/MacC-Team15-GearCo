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
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    private let texts = TextLiterals.PlanBatchSetting.self
    @State private var isAlertShowing = false
    
    var body: some View {
        RootDefaultSpacingVStack {
            viewHeader
            viewBody
        }
    }
   
    private var viewHeader: some View {
        BackButtonOnlyHeader()
    }
    
    private var viewBody: some View {
        VStack(alignment: .leading, spacing: K.rootVStackSpacing) {
            settingTitle
            solidCycleGapSelectionView
            ThickDivider()
            solidDisplayDateTypeSelectionView
                .padding(.top, K.displayDateTypeTopPadding)
            Spacer()
            deleteWholeCalendarView
        }
        .alert(
            texts.Alert.title,
            isPresented: $isAlertShowing
        ) {
            Button(texts.Alert.leftButtonText, role: .cancel) { }
            Button(texts.Alert.rightButtonText, role: .destructive) {
                mealPlansOB.deleteAllPlans()
            }
        } message: {
            Text(texts.Alert.description)
        }
        .defaultHorizontalPadding()
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
                isAlertShowing = true
            }
        }
        .padding(.bottom, 60-34)
    }
}

extension PlanBatchSettingView {
    private enum K {
        static var rootVStackSpacing: CGFloat { 40 }
        static var titleColor: Color { .defaultText }
        static var hintColor: Color { .defaultText.opacity(0.4) }
        static var titleHintSpacing: CGFloat { 14 }

        static var displayDateTypeTopPadding: CGFloat { -7 }
        static var deleteWholeCalendarButtonTextColor: Color { .defaultText.opacity(0.8) }
    }
}

struct PlanBatchSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PlanBatchSettingView().environmentObject(UserOB()).environmentObject(MealPlansOB())
    }
}
