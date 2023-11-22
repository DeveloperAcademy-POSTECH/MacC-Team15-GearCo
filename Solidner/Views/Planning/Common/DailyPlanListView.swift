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
    private let texts = TextLiterals.DailyPlanList.self
    private enum K {
        static var rootVStackSpacing: CGFloat { 16 }
        static var vStackSpacingInscroll: CGFloat { 26 }
        // title
        static var titleTextColor: Color { .defaultText }
        // meal Group List
        static var mealGroupVstackSpacing: CGFloat { 40 }

        // add meal plan button
        static var addMealPlanButtonBgColor: Color { Color.buttonBgColor }
        static var addMealPlanButtonTitleColor: Color { Color.buttonDisabledTextColor.opacity(0.6) }
    }

    let date: Date
    let mealPlans: [MealPlan]
    private(set) var mealsDict = [SolidDate:[MealPlan]]()
    // TODO: - 나중에 어떻게 선언해야할지 고민 State? Binding? 계획이 바뀌었을 때, 바뀐 계획에 따라서 값이 바뀌어야함.
    let isWrongPlan: Bool

    init(
        mealPlans: [MealPlan] = MealPlan.mockMealsOne,
        date: Date = Date(),
        isWrongPlan: Bool = false
    ) {
        self.date = date
        self.mealPlans = mealPlans
        self.isWrongPlan = isWrongPlan
        mealsDict = Dictionary(grouping: mealPlans) { SolidDate(startDate: $0.startDate, endDate: $0.endDate) }
    }

    var body: some View {
        VStack(spacing: K.rootVStackSpacing) {
            ScrollView {
                VStack(spacing: K.vStackSpacingInscroll) {
                    title
                    if isWrongPlan {
                        WarningView()
                    }
                    mealGroupList
                }
            }
            addMealPlanButton
        }
    }
}

// MARK: - title

extension DailyPlanListView {
    private var title: some View {
        HStack {
            Text(texts.titleText(date))
                .headerFont2()
                .foregroundStyle(K.titleTextColor)
            Spacer()
        }
    }
}

// MARK: - meal group list

extension DailyPlanListView {
    private var mealGroupList: some View {
        VStack(spacing: K.mealGroupVstackSpacing) {
            let mealDictKeys = Array(mealsDict.keys.sorted(by: { $0.startDate < $1.startDate }).enumerated())

            ForEach(mealDictKeys, id: \.element) { index, solidDate in
                if let meals = mealsDict[solidDate] {
                    MealGroupView(
                        dateRange: solidDate.description,
                        displayDateInfo: DisplayDateInfoView(
                            from: solidDate.startDate,
                            to: solidDate.endDate),
                        mealPlans: meals,
                        isInList: false
                    )
                }
            }
        }
    }
}

// MARK: - add meal plan button

extension DailyPlanListView {
    // TODO: - add Meal Plan Button 구현
    private var addMealPlanButton: some View {
        ButtonComponents(.big,
                         title: texts.addMealPlanText) {
            print(#function)
        }
         .buttonColor(K.addMealPlanButtonBgColor)
         .titleColor(K.addMealPlanButtonTitleColor)
    }
}

// MARK: - solid date
// TODO: - solidDate를 model로 빼도 될듯

extension DailyPlanListView {
    struct SolidDate: Hashable {
        let startDate: Date
        let endDate: Date

        var description: String {
            TextLiterals.PlanList.dateRangeString(
                start: startDate,
                end: endDate
            )
        }
    }
}

struct DailyPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyPlanListView(
            mealPlans: MealPlan.mockMealsOne,
            date: Date(),
            isWrongPlan: true
        ).environmentObject(UserOB())
    }
}
