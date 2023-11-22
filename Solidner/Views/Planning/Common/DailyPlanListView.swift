//
//  DailyPlanListView.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct DailyPlanListView: View {
    @EnvironmentObject var user: UserOB
    let mealPlans: [MealPlan]
    let texts = TextLiterals.DailyPlanList.self
    private(set) var mealsDict = [SolidDate:[MealPlan]]()

    // TODO: - 나중에 어떻게 선언해야할지 고민 State? Binding? 계획이 바뀌었을 때, 바뀐 계획에 따라서 값이 바뀌어야함.
    private(set) var isWrongPlan: Bool = true

    init(mealPlans: [MealPlan] = MealPlan.mockMealsOne) {
        self.mealPlans = mealPlans
        mealsDict = Dictionary(grouping: mealPlans) { SolidDate(startDate: $0.startDate, endDate: $0.endDate) }
    }

    var body: some View {
        VStack {
            ScrollView {
                title
                if isWrongPlan {
                    WarningView()
                }
                mealGroupList
            }
            addMealPlanButton
        }
    }

    private var title: some View {
        HStack {
            Text("11/23(금) 식단")
                .font(.largeTitle).bold()
            Spacer()
        }
    }

    private var mealGroupList: some View {
        VStack(spacing: 20) {
            ForEach(Array(mealsDict.keys.sorted(by: { $0.startDate < $1.startDate }).enumerated()), id: \.element) { index, solidDate in
                if let meals = mealsDict[solidDate] {
                    MealGroupView(
                        dateRange: solidDate.description,
                        displayDateInfo: user.displayDateType.textInfo(of: user, from: solidDate.startDate, to: solidDate.endDate),
                        mealPlans: meals,
                        isInList: false
                    )
                }
            }
        }
    }

    private var addMealPlanButton: some View {
        Button {
            print(#function)
        } label: {
            Text(texts.addMealPlanText)
        }
    }
}

extension DailyPlanListView {
    struct SolidDate: Hashable {
        let startDate: Date
        let endDate: Date

        var description: String {
            TextLiterals.PlanList.dateRangeString(start: startDate, end: endDate)
        }
    }
}

struct DailyPlanListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyPlanListView(mealPlans: MealPlan.mockMealsOne).environmentObject(UserOB())
    }
}
