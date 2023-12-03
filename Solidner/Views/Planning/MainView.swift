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
    @State private var selectedMonthDate = Date()
    
    var body: some View {
        NavigationStack {
            if isLoading {
                VStack {
                    LottieView(jsonName: "solidnerLoadingAnimation")
                        .frame(width: 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.secondBgColor)
            } else {
                if mealPlansOB.mealPlans.isEmpty {
                    // plan이 없을 시(초기)
                    StartPlanView()
                } else {
                    Group {
                        if showWeekly {
                            PlanListView(showWeekly: $showWeekly, selectedMonthDate: $selectedMonthDate)
                        } else {
                            MonthlyPlanningView(showWeekly: $showWeekly, selectedMonthDate: $selectedMonthDate)
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

