//
//  SolidnerApp.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/06.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SolidnerApp: App {
    // Firebase Setup.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isOnboardingOn") var isOnboardingOn = true
    
    @StateObject private var mealPlansOB = MealPlansOB(mealPlans: MealPlan.mockMealsOne)
    let ingredientData = IngredientData.shared
    @StateObject private var userOB = UserOB()
    
    var body: some Scene {
        WindowGroup {
//            let isPlanEmpty = mealPlansOB.mealPlans.isEmpty
            let isPlanEmpty = false
            
            #warning("이거 더 좋은 방법으로 정리해줄 사람~~")
//            if isOnboardingOn {
//                //                    SignInView()
                NavigationStack {
                    AgreeToTermsView()
                }
                .environmentObject(userOB)
//            } else if isPlanEmpty {
//                NavigationStack {
//                    StartPlanView()
//                }
//                .environmentObject(userOB)
//                .environmentObject(mealPlansOB)
//            } else {
//                NavigationStack {
//                    PlanListView()
//                }
//                .environmentObject(userOB)
//                .environmentObject(mealPlansOB)
//                //                    MonthlyPlanningView()
//            }

            // MypageRootView().environmentObject(userOB)
            
//            MealDetailView(startDate: Date(), cycleGap: userOB.planCycleGap)
//                .environmentObject(userOB)
//                .environmentObject(mealPlansOB)
        }
    }
}

