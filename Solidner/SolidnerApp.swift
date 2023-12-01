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
    
    let ingredientData = IngredientData.shared
    @StateObject private var userOB = UserOB()
    @State private var finishLaunchScreen = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                if finishLaunchScreen {
                    // 로그인 여부에 따른 뷰 분기처리는 여기에
                    SignInView()
                } else {
                    LaunchScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    finishLaunchScreen.toggle()
                                }
                            }
                        }
                }
            }
        }
    }
}
