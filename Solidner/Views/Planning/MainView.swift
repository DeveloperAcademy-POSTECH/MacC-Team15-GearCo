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
    
    var body: some View {
        MonthlyPlanningView()
            .environmentObject(mealPlansOB)
            .task {
                await mealPlansOB.loadAllPlans()
            }
    }
}

