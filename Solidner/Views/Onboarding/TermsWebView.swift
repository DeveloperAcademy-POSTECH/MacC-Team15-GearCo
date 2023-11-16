//
//  WebView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/16.
//

import SwiftUI
import WebKit
 
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
    var agreeCase: AgreeCase
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<TermsWebView>) {
        
    }
}
 
struct TermsWebView_Previews: PreviewProvider {
    static var previews: some View {
        TermsWebView(agreeCase: .serviceUse)
    }
}


