//
//  TeamIntroductionView.swift
//  Solidner
//
//  Created by 황지우2 on 11/26/23.
//

import SwiftUI

struct ServiceInfoView: View {
    private let appAppleID = "6473099677"
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 0) {
                BackButtonAndTitleHeader(title: "서비스 정보 및 문의")
                viewBody()
                    .padding(horizontal: 20, top: 15.88, bottom: 30)
            }
//            .background {
//                Image(.buyMeACoffeeBg)
//                    .resizable()
//                    .edgesIgnoringSafeArea(.all)
//                    .frame(width: UIScreen.getWidth(390), height: UIScreen.getWidth(844))
//            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    private func viewBody() -> some View {
        VStack(spacing: 0) {
            Image(.solidnerThumbnail)
                .resizable()
                .scaledToFit()
            snsLinkList()
                .padding(.top, 36)
            ViewDivider(dividerCase: .thick)
                .padding(.top, 22)
            communicationLinkList()
                .padding(.top, 22)
            Spacer()
//            donationItem()
        }
    }
    private func donationItem() -> some View {
        HStack {
            Text("개발자에게 커피 한 잔의 마음")
                .headerFont6()
                .foregroundStyle(Color.defaultText.opacity(0.8))
            Spacer()
            Button(action: {
                // 후원
            }, label: {
                Text("건네주기")
                    .toastFont()
                    .foregroundStyle(Color.defaultText_wh)
                    .symmetricBackground(HPad: 14, VPad: 9, color: .accentColor1, radius: 12)
            })
        }
        .symmetricBackground(HPad: 20, VPad: 15, color: .defaultText_wh, radius: 12)
    }
    private func communicationLinkList() -> some View {
        VStack(spacing: 30) {
            communicationLinkItem(communicationLinkCase: .serviceQNA)
            communicationLinkItem(communicationLinkCase: .appReview)
        }
    }
    private func communicationLinkItem(communicationLinkCase: CommunicationLinkCase) -> some View {
        Button {
            switch communicationLinkCase {
            case .serviceQNA:
                openKakaoChannelLink()
            case .appReview:
                openAppStore(appId: appAppleID)
            }
        } label: {
            HStack {
                Text(communicationLinkCase.rawValue)
                    .headerFont5()
                    .foregroundStyle(Color.defaultText.opacity(0.8))
                Spacer()
                Image(.mypageChevron)
            }
        }
    }
    private func snsLinkList() -> some View {
        VStack(spacing: 30) {
            snsLinkItem(snsLinkCase: .solidnerInfo)
            snsLinkItem(snsLinkCase: .teamInfo)
        }
    }
    private func snsLinkItem(snsLinkCase: SNSLinkCase) -> some View {
        HStack {
            Text(snsLinkCase.rawValue)
                .headerFont4()
                .foregroundStyle(Color.defaultText.opacity(0.8))
            Spacer()
            Button(action: {
                openInstagramProfile(username: snsLinkCase == .solidnerInfo ? "solidner.app" : "gearco_official")
            }, label: {
                snsLinkChip(snsLinkCase: snsLinkCase)
            })
        }
    }
    private func openInstagramProfile(username: String) {
        if let instagramURL = URL(string: "https://www.instagram.com/\(username)"), UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        } else {
            if let appStoreURL = URL(string: "https://apps.apple.com/us/app/instagram/id389801252") {
                UIApplication.shared.open(appStoreURL)
            }
        }
    }
    private func openKakaoChannelLink() {
        if let channelURL = URL(string: "http://pf.kakao.com/_EcJxjG"), UIApplication.shared.canOpenURL(channelURL) {
            UIApplication.shared.open(channelURL)
        }
    }
    private func openAppStore(appId: String) {
        let url = "itms-apps://itunes.apple.com/app/" + appId
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    private func snsLinkChip(snsLinkCase: SNSLinkCase) -> some View {
        VStack(alignment: .trailing, spacing: 6) {
            HStack(spacing: 8) {
                Image(.instaIcon)
                Text(snsLinkCase == .solidnerInfo ? "solidner.app" : "gearco_official")
                    .bodyFont2()
                    .foregroundStyle(Color.defaultText.opacity(0.8))
            }
            Rectangle()
                .fill(Color.underLineText)
                .frame(height: 1)
                .frame(width: snsLinkCase == .solidnerInfo ? 84 : 99)
        }
    }
    private enum SNSLinkCase: String {
        case solidnerInfo = "솔리너 계정"
        case teamInfo = "팀 계정"
    }
    private enum CommunicationLinkCase: String {
        case serviceQNA = "솔리너에게 문의하기"
        case appReview = "리뷰 남기러 가기"
    }
}

#Preview {
    ServiceInfoView()
}
