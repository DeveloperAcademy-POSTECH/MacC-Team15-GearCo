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
    
    @StateObject private var userOB = UserOB()
    var body: some Scene {
        WindowGroup {
            //SignInView().environmentObject(userOB)
            AgreeToTermsView().environmentObject(userOB)
        }
    }
}
