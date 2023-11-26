//
//  DailyPlanListView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

// !!!: - 남은 TODO 갯수: 3개

import SwiftUI

struct DailyPlanListView: View {
    @EnvironmentObject private var user: UserOB
    @State private var isMealAdding: Bool = false
    private let texts = TextLiterals.DailyPlanList.self

    let date: Date
    let mealPlans: [MealPlan]
    var mealPlanGroups: [MealPlanGroup] {
        MealPlanGroup.build(with: mealPlans).sorted { $0.solidDate.startDate < $1.solidDate.startDate }
    }
    // TODO: - 나중에 어떻게 선언해야할지 고민 State? Binding? 계획이 바뀌었을 때, 바뀐 계획에 따라서 값이 바뀌어야함.
    let isWrongPlan: Bool

    init(
        date: Date = Date(),
        mealPlans: [MealPlan] = MealPlan.mockMealsOne,
        isWrongPlan: Bool = false
    ) {
        self.date = date
        self.mealPlans = mealPlans
        self.isWrongPlan = isWrongPlan
    }

    var body: some View {
        RootVStack {
            viewHeader
            viewBody
        }
    }
}

extension DailyPlanListView {
    private var viewHeader: some View {
        BackButtonOnlyHeader()
    }
    
    private var viewBody: some View {
        VStack(spacing: K.rootVStackSpacing) {
            ScrollView {
                VStack(alignment: .leading, spacing: K.vStackSpacingInscroll) {
                    title
                    if isWrongPlan {
                        WarningView()
                    }
                    mealGroupList
                }
            }
            addMealPlanButton
        }
        .navigationDestination(isPresented: $isMealAdding) {
            MealDetailView(
                startDate: date,
                cycleGap: user.planCycleGap
            )
        }
        .defaultHorizontalPadding()
    }
}

// MARK: - title

extension DailyPlanListView {
    private var title: some View {
        Text(texts.titleText(date))
            .customFont(.header2, color: .defaultText)
    }
}

// MARK: - meal group list

extension DailyPlanListView {
    private var mealGroupList: some View {
        VStack(spacing: K.mealGroupVstackSpacing) {
            ForEach(mealPlanGroups, id:\.self) { mealPlanGroup in
                MealGroupView(
                    mealPlanGroup: mealPlanGroup,
                    isInPlanList: false
                )
            }
        }
    }
}

extension DailyPlanListView {
    private var addMealPlanButton: some View {
        ButtonComponents(.big,
                         title: texts.addMealPlanText) {
            isMealAdding = true
        }
         .buttonColor(.buttonBgColor)
         .titleColor(K.addMealPlanButtonTitleColor)
    }
}

extension DailyPlanListView {
    private enum K {
        static var rootVStackSpacing: CGFloat { 16 }
        static var vStackSpacingInscroll: CGFloat { 26 }

        // meal Group List
        static var mealGroupVstackSpacing: CGFloat { 40 }

        // add meal plan button
        static var addMealPlanButtonTitleColor: Color { Color.buttonDisabledTextColor.opacity(0.6) }
    }
}

struct DailyPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyPlanListView(
            date: Date(),
            mealPlans: MealPlan.mockMealsOne,
            isWrongPlan: true
        ).environmentObject(UserOB())
    }
}
