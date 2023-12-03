//
//  WebView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/16.
//

import SwiftUI
import WebKit
import Lottie

struct TermsWebView: UIViewRepresentable {
    var urlToLoad: String {
        switch agreeCase {
        case .serviceUse:
            return TextLiterals.TermsWeb.serviceUseUrl
        case .personalInfo:
            return TextLiterals.TermsWeb.personalInfoUrl
        case .advertising:
            return TextLiterals.TermsWeb.advertisingURL
        }
    }
    let agreeCase: AgreeCase
    
//    var activityIndicator = UIActivityIndicatorView(style: .large)
//    var activityIndicator = LottieView(jsonName: "solidnerLoadingAnimation").frame(width: 40)
    var loadingLottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named("solidnerLoadingAnimation")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundBehavior = .pauseAndRestore

        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()

        webView.addSubview(loadingLottieAnimationView)
        NSLayoutConstraint.activate([
            loadingLottieAnimationView.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            loadingLottieAnimationView.centerYAnchor.constraint(equalTo: webView.centerYAnchor),
            loadingLottieAnimationView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
        
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<TermsWebView>) {
        loadingLottieAnimationView.play { (finished) in
            loadingLottieAnimationView.isHidden = true
        }
        guard let url = URL(string: self.urlToLoad) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> WebViewHelper {
        WebViewHelper(self)
    }
}

class WebViewHelper: NSObject, WKNavigationDelegate {
    let webView: TermsWebView

    init(_ webView: TermsWebView) {
        self.webView = webView
        super.init()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.loadingLottieAnimationView.stop()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView.loadingLottieAnimationView.stop()
        print("error: \(error)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView.loadingLottieAnimationView.stop()
        print("error: \(error)")
    }
}

struct TermsWebView_Previews: PreviewProvider {
    static var previews: some View {
        TermsWebView(agreeCase: .serviceUse)
    }
}

struct TermsWebViewWithHeader: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    let agreeCase: AgreeCase
    var body: some View {
        VStack {
            BackButtonHeader(action: {
                presentationMode.wrappedValue.dismiss()
            }, title: agreeCase.rawValue)
            TermsWebView(agreeCase: agreeCase)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

