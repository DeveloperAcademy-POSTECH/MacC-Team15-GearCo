//
//  MypageRootView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/24.
//

import SwiftUI

struct MypageRootView: View {
    @EnvironmentObject var user: UserOB
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                BackButtonHeader(action: {
                    //Navigate Back
                }, title: "프로필")
                viewBody()
                    .padding(horizontal: 20, vertical: 39)
            }
        }
    }
    private func viewBody() -> some View {
        return VStack(spacing: 0) {
            changeProfileInfo()
            ViewDivider(dividerCase: .thin)
                .padding(.top, 16)
            profileInfoList()
                .padding(.top, 30)
            ViewDivider(dividerCase: .thick)
                .padding(.top, 28)
            myPageFunctionList()
                .padding(.top, 28)
            Spacer()
        }
    }
    private func changeProfileInfo() -> some View {
        return HStack(spacing: 0) {
            Text("회원정보")
                .headerFont4()
                .foregroundColor(.defaultText.opacity(0.8))
            Spacer()
            ButtonComponents(.tiny, title: "수정하기", disabledCondition: false, action: {
                //회원정보 수정으로 Navigation
            })
        }
    }
    private func profileInfoList() -> some View {
        return VStack(spacing: 32) {
            profileInfoItem(profileItemCase: .nickName)
            profileInfoItem(profileItemCase: .babyName)
            profileInfoItem(profileItemCase: .babyBirthDate)
            profileInfoItem(profileItemCase: .solidStartDate)
        }
    }
    private func profileInfoItem(profileItemCase: ProfileItemCase) -> some View {
        return HStack {
            Text(profileItemCase == .babyBirthDate ? user.babyName+profileItemCase.rawValue : profileItemCase.rawValue)
                .headerFont5()
                .foregroundColor(.defaultText.opacity(0.8))
            Spacer()
            Text(profileInfoData(profileItemCase: profileItemCase))
                .bodyFont1()
                .foregroundColor(.defaultText.opacity(0.8))
        }
    }
    private func profileInfoData(profileItemCase: ProfileItemCase) -> String {
        switch profileItemCase {
        case .nickName:
            return user.nickName
        case .babyName:
            return user.babyName
        case .babyBirthDate:
            return user.babyBirthDate.formatted(.yyyyMMdd_dotWithSpace)
        case .solidStartDate:
            return user.solidStartDate.formatted(.yyyyMMdd_dotWithSpace)
        }
    }
    private enum ProfileItemCase: String {
        case nickName = "내 닉네임"
        case babyName = "자녀 이름"
        case babyBirthDate = "의 생일"
        case solidStartDate = "이유식 시작일"
    }
    private enum MypageFunctionCase: String {
        case notificationSetting = "알림 설정"
        case teamIntroduction = "서비스를 만든 사람들"
        case personalInfoTerms = "개인정보 처리약관"
        case serviceUseTerms = "서비스 이용약관"
        case withdrawal = "탈퇴하기"
    }
    private func myPageFunctionButton(mypageFuctionCase: MypageFunctionCase) -> some View {
        return Button {
            // 각 뷰로 네비게이션
        } label: {
            HStack {
                Text(mypageFuctionCase.rawValue)
                    .headerFont4()
                    .foregroundColor(mypageFuctionCase == .notificationSetting ||  mypageFuctionCase == .teamIntroduction ? .secondaryText : .tertinaryText)
                Spacer()
                Image(assetName: .mypageChevron)
            }
        }
    }
    private func myPageFunctionList() -> some View {
        return VStack(spacing: 32) {
            myPageFunctionButton(mypageFuctionCase: .notificationSetting)
            myPageFunctionButton(mypageFuctionCase: .teamIntroduction)
            myPageFunctionButton(mypageFuctionCase: .personalInfoTerms)
            myPageFunctionButton(mypageFuctionCase: .serviceUseTerms)
            ViewDivider(dividerCase: .thick)
                .padding(.top, -4)
            myPageFunctionButton(mypageFuctionCase: .withdrawal)
                .padding(.top, -4)
        }
    }
}

struct MypageRootView_Previews: PreviewProvider {
    static var previews: some View {
        MypageRootView().environmentObject(UserOB())
    }
}
