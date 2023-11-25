//
//  NotificationSettingView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct NotificationSettingView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                BackButtonHeader(action: {
                    presentationMode.wrappedValue.dismiss()
                }, title: "알림 설정")
                viewBody()
                    .padding(horizontal: 20, top: 32, bottom: 0)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("이유식 정보부터 다양한 소식을\n전달해 드릴게요")
                    .bodyFont1()
                .foregroundStyle(Color.primeText.opacity(0.6))
                Spacer()
            }
            ViewDivider(dividerCase: .thin)
                .padding(.top, 26)
            settingList()
                .padding(.top, 26)
            Spacer()
        }
    }
    private func settingList() -> some View {
        VStack(spacing: 29) {
            settingLabelAndSwitch(settingCase: .appAlarm)
            settingLabelAndSwitch(settingCase: .agreeToAd)
        }
    }
    private func settingLabelAndSwitch(settingCase: SettingCase) -> some View {
        Toggle(isOn: settingCase == .appAlarm ? $user.isAppAlarmOn : $user.isAgreeToAdvertising, label: {
            Text(settingCase.rawValue)
                .headerFont4()
                .foregroundStyle(Color.defaultText.opacity(0.8))
        })
        .toggleStyle(SwitchToggleStyle(tint: .accentColor1))
    }
    private enum SettingCase: String {
        case appAlarm = "앱 알림"
        case agreeToAd = "마케팅 정보 수신 동의"
    }
}

#Preview {
    NotificationSettingView().environmentObject(UserOB())
}
