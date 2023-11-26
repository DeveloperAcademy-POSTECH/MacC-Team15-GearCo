//
//  MealGroupView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

// TODO: - 새로운 재료는 accentColor1로 색 바꾸기
// TODO: - mealGroup 눌렀을 때 action - PlanDetailView로 이동해야 함
// TODO: - meal 눌렀을 때 action - MealDetailView로 이동해야 함
// 사용되는 뷰
//   PlanListView, DailyListView

import SwiftUI

struct MealGroupView<Content>: View where Content: View {
    enum MealGroupViewType {
        case normal, addNew
    }
    let type: MealGroupViewType

    let dateRange: String
    let displayDateInfo: Content
    let mealPlans: [MealPlan]
    let isInPlanList: Bool
    let isTodayInDateRange: Bool
    let isWrongPlan: Bool
    private let texts = TextLiterals.MealGroup.self
    let action: () -> ()

    init(
        type: MealGroupViewType = .normal,
        dateRange: String,
        displayDateInfo: Content = EmptyView(),
        mealPlans: [MealPlan] = [],
        isInPlanList: Bool = true,
        isTodayInDateRange: Bool = false,
        isWrongPlan: Bool = true,
        action: @escaping () -> Void = {}
    ) {
        self.type = type
        self.dateRange = dateRange
        self.displayDateInfo = displayDateInfo
        self.mealPlans = mealPlans
        self.isInPlanList = isInPlanList
        self.isTodayInDateRange = isTodayInDateRange
        self.isWrongPlan = isWrongPlan
        self.action = action
    }

    var body: some View {
        VStack(spacing: K.wholeVStackSpacing) {
            dateInformation
            if isInPlanList {
                // PlanListView에서는 전체가 눌린다.
                mealGroupInPlanList
            } else {
                // DailyListView에서는 끼니 별로 눌린다.
                mealGroup
            }
        }
    }
}

// MARK: - date Information

extension MealGroupView {
    private var dateInformation: some View {
        // planList이면서 wrong plan이라면 noti circle이 보인다.
        let showNotiCircle = isInPlanList && isWrongPlan
        return HStack(alignment: .bottom, spacing: K.dateInformationHStackSpacing) {
            if showNotiCircle { notiCircle }
            Text(dateRange)
                .dayDisplayFont1()
                .foregroundStyle(K.dayDisplayTextColor)
            Spacer()
            displayDateInfo
        }
    }

    private var notiCircle: some View {
        VStack {
            Spacer()
            Circle()
                .frame(
                    width: K.notiCircleSize,
                    height: K.notiCircleSize
                )
                .foregroundStyle(K.notiCircleColor)
            Spacer()
        }
    }
}

// MARK: - meal group

extension MealGroupView {
    private var mealGroupInPlanList: some View {
        Button {
            // TODO: - planDetailView로 이동해야 함
            action()
        } label: {
            if type == .normal { mealGroup }
            else { addNewMealPlan }
        }
    }

    private var mealGroup: some View {
        VStack(spacing: .zero) {
            let lastIndex = mealPlans.indices.last
            ForEach(Array(mealPlans.sorted(by: { $0.mealType.rawValue < $1.mealType.rawValue }).enumerated()), id:\.element) { index, mealPlan in
                mealView(of: mealPlan)
                if index != lastIndex {
                    mealDivider
                }
            }
        }
        .background(backgroundRectangle)
        .clipped()
    }

    private var addNewMealPlan: some View {
        HStack {
            Text(texts.addIngredientText)
                .headerFont5()
                .foregroundStyle(K.addNewPlanTextColor)
            Spacer()
            chevron
        }
        .padding()
        .foregroundStyle(K.addNewPlanTextColor)
        .frame(height: K.addNewPlanHeight)
        .padding(.bottom, K.addNewPlanBottomPadding)
        .background(backgroundRectangle)
    }

    private func mealView(of mealPlan: MealPlan) -> some View {
        // TODO: - meal 눌렀을 때 action - MealDetailView로 이동해야 함
        Button {
            action()
        } label: {
            HStack {
                mealIcon(of: mealPlan)
                ingredientText(of: mealPlan)
                Spacer()
                if isInPlanList == false {
                    chevron
                }
            }
            .padding(
                top: K.mealViewPadding,
                leading: K.mealViewPadding,
                bottom: K.mealViewPadding,
                trailing: K.mealViewTrailingPadding
            )
        }
        .frame(minHeight: K.mealViewMinHeight)
        .disabled(isInPlanList)
    }

    private var mealDivider: some View {
        Rectangle()
            .padding(.horizontal, isInPlanList ? K.dividerInListPadding : K.dividerNotInListPadding )
            .frame(height:K.dividerHeight)
            .foregroundStyle(K.backgroundStrokeNormalColor)
    }

    private var backgroundRectangle: some View {
        let isStrokeHighlight = isInPlanList && isTodayInDateRange
        return RoundedRectangle(cornerRadius: K.backgroundRectangleRadius)
            .fill(.white,
                  strokeBorder: isStrokeHighlight ? K.backgroundHighlightStrokeColor : K.backgroundStrokeNormalColor,
                  lineWidth: K.backgroundStrokeLineWidth)
    }
}

// MARK: - Meal View

extension MealGroupView {
    private func mealIcon(of mealPlan: MealPlan) -> some View {
        Image(systemName: mealPlan.mealType.icon)
            .font(.body)
            .foregroundStyle(K.mealIconColor)
    }

    private func ingredientText(of mealPlan: MealPlan) -> some View {
        Text(mealPlan.ingredientsString)
            .headerFont5()
            .foregroundStyle(K.testedIngredientTextColor)
    }

    private var chevron: some View {
        Image(systemName: K.chevronRightSFSymbolName)
            .foregroundStyle(K.chevronColor)
            .bold()
    }
}

extension MealGroupView {
    private enum K {
        static var wholeVStackSpacing: CGFloat { 16 }
        // dateInformation
        static var dayDisplayTextColor: Color { .defaultText.opacity(0.4) }
        static var notiCircleColor: Color { .accentColor1 }
        static var notiCircleSize: CGFloat { 6 }
        static var dateInformationHStackSpacing: CGFloat { 6 }
        // meal group
        static var dividerInListPadding: CGFloat { 19 }
        static var dividerNotInListPadding: CGFloat { -30 }
        static var dividerHeight: CGFloat { 1.4 }

        static var chevronRightSFSymbolName: String { "chevron.right" }
        static var chevronColor: Color { .quarternaryText }

        // mealview
        static var mealViewPadding: CGFloat { 18 }
        static var mealViewMinHeight: CGFloat { 64 }
        static var mealViewTrailingPadding: CGFloat { 12 }
        static var mealIconColor: Color { .accentColor2 }
        static var testedIngredientTextColor: Color { .primeText }
        // background
        static var backgroundRectangleRadius: CGFloat { 12 }
        static var backgroundStrokeNormalColor: Color { .listStrokeColor }
        static var backgroundHighlightStrokeColor: Color { .accentColor1 }
        static var backgroundStrokeLineWidth: Double { 2 }
        static var addNewPlanHeight: Double { 64 }
        static var addNewPlanBottomPadding: Double { 6 }
        static var addNewPlanTextColor: Color { .defaultText.opacity(0.6) }
    }

}
