//
//  MainView.swift
//  Solidner
//
//  Created by 이재원 on 11/28/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var user: UserOB
    @StateObject private var mealPlansOB = MealPlansOB()
    @State private var showWeekly = true
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView().frame(maxHeight: .infinity)
            } else {
                if mealPlansOB.mealPlans.isEmpty {
                    // plan이 없을 시(초기)
                    StartPlanView()
                } else {
                    Group {
                        if showWeekly {
                            PlanListView(showWeekly: $showWeekly)
                        } else {
                            MonthlyPlanningView(showWeekly: $showWeekly)
                        }
                    }
                    .navigationDestination(for: Date.self) { date in
                        let mealPlans = mealPlansOB.getMealPlans(in: date)
                        if mealPlans.count != .zero {
                            DailyPlanListView(date: date, mealPlans: mealPlans)
                        } else {
                            MealDetailView(
                                startDate: date,
                                cycleGap: user.planCycleGap,
                                mealPlansOB: mealPlansOB
                            )
                        }
                    }
                    .navigationDestination(for: MealPlan.self) { mealPlan in
                        MealDetailView(
                            mealPlan: mealPlan,
                            cycleGap: mealPlan.cycleGap,
                            mealPlansOB: mealPlansOB
                        )
                    }
                    .navigationDestination(for: MealPlanGroup.self) { mealPlanGroup in
                        PlanGroupDetailView(mealPlanGroup: mealPlanGroup)
                    }
                }
            }
        }.environmentObject(mealPlansOB)
        .task {
            await mealPlansOB.loadAllPlans()
            print("loadPlans")
            withAnimation(.linear(duration: 0.1)) {
                isLoading = false
            }
        }
    }
}

