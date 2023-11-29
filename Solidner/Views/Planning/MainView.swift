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
    
    var body: some View {
        Group {
            if showWeekly {
                PlanListView(showWeekly: $showWeekly)
            } else {
                MonthlyPlanningView(showWeekly: $showWeekly)
            }
        }.environmentObject(mealPlansOB)
        .task {
            await mealPlansOB.loadAllPlans()
        }
    }
}

