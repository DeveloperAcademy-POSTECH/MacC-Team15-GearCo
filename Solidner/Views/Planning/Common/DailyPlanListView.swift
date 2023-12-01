//
//  DailyPlanListView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

// !!!: - 남은 TODO 갯수: 3개

import SwiftUI

struct DailyPlanListView: View {
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    @EnvironmentObject private var user: UserOB
    @State private var isMealAdding: Bool = false
    private let texts = TextLiterals.DailyPlanList.self

    let date: Date
    @State private var mealPlans: [MealPlan]
    var mealPlanGroups: [MealPlanGroup] {
        MealPlanGroup.build(with: mealPlans)
    }
    
    // TODO: - 계획이 바뀌었을 때, 바뀐 계획에 따라서 값이 바뀌는지 확인하기
    var isWrongPlan: Bool {
        WrongPlanChecker.isWrongPlan(mealPlans)
    }

    init(
        date: Date = Date(),
//        mealPlans: [MealPlan] = [MealPlan.mockMealsOne],
        mealPlans: [MealPlan] = []
    ) {
        self.date = date
        self._mealPlans = State(initialValue: mealPlans)
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
    
    // MARK: - view body
    
    private var viewBody: some View {
        VStack(spacing: K.rootVStackSpacing) {
            if mealPlanGroups.isEmpty {
                VStack(alignment: .leading) {
                    title
                    emptyView
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: K.vStackSpacingInscroll) {
                        title
                        if isWrongPlan {
                            WarningView()
                        }
                        mealGroupList
                    }
                }
            }
            addMealPlanButton
        }
        .defaultViewBodyTopPadding()
        .defaultHorizontalPadding()
        .navigationDestination(isPresented: $isMealAdding) {
            MealDetailView(
                startDate: date,
                cycleGap: user.planCycleGap,
                mealPlansOB: mealPlansOB
            )
        }
        .onChange(of: mealPlansOB.filteredMealPlans) { newValue in
            mealPlans = mealPlansOB.getMealPlans(in: date)
        }
    }
}

// MARK: - title

extension DailyPlanListView {
    private var title: some View {
        Text(texts.titleText(date))
            .customFont(.header2, color: .defaultText)
    }
}

// MARK: - PlanEmptyView

extension DailyPlanListView {
    private var emptyView: some View {
        PlanEmptyView()
            .frame(maxWidth: .infinity)
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

// MARK: - add meal plan button
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
            mealPlans: []
        )
        .environmentObject(UserOB())
        .environmentObject(MealPlansOB())
    }
}
