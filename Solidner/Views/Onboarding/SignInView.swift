//
//  SignInView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/07.
//

import SwiftUI
import FirebaseAuth
import CryptoKit
import AuthenticationServices
import Firebase

// AppleUser 객체를 Codable로 설정하여
// Encoding, Decoding이 가능 => UserDefault에 저장이 가능한 형태로.
struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else {return nil}
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct SignInView: View {
    @EnvironmentObject var user: UserOB
    @StateObject var loginData = AppleLoginOB()
    @State private var currentNonce: String?
    @State private var isLoading = false
    var body: some View {
        ZStack {
            BackgroundView()
            if isLoading {
                ZStack {
                    VStack {
                        Spacer()
                        SignInWithAppleButton(
                            onRequest: configure,
                            onCompletion: handle)
                        .frame(width: 335, height: 56)
                        .cornerRadius(12)
                        .padding(.bottom, 21)
                    }
                    .background(
                        Image(assetName: .loginBg)
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.getWidth(390), height: UIScreen.getWidth(844))
                    )
                    Image(assetName: .loginTypo)
                        .resizable()
                        .frame(width: UIScreen.getWidth(250.86), height: UIScreen.getWidth(52))
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1 , execute: {
                withAnimation { isLoading.toggle() }
            })
        }
    }
    
    private func failHandler(errString1: String, errString2: String) {
        print("error on apple login: \(errString1), \(errString2)")
    }
    
    private func configure(_ request: ASAuthorizationAppleIDRequest) {
        loginData.nonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(loginData.nonce)
    }
    
    private func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult{
        case .success(let auth):
            print(auth)
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let appleUser = AppleUser(credentials: appleIdCredentials) {
                    // AppleUser 객체를 JSON 형태로 Encoding하여 UserDefaults에 저장할 수 았는 형태로.
                    let appleUserData = try? JSONEncoder().encode(appleUser)
                    // UserDefaults에 Register한 User의 정보 저장. 초회차 로그인(Register) 이후에는 유저 데이터에 접근할 수 없으므로
                    // 데이터를 유실하지 않도록 신중하게 관리하여 DB에 업로드해야 함.
                    // Data는 Encoding한 AppleUser 객체, key는 유일성을 보장할 수 있는 userId로 설정.
                    UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                    
                    print(">>> Saved Apple User : ", appleUser)
                } else {    // field 정보 부족으로 AppleUser 객체 생성 실패 시
                    print("missing some fields",
                          appleIdCredentials.email ?? "" ,
                          appleIdCredentials.fullName ?? "",
                          appleIdCredentials.user )
                }
                
                // ------ Firebase Login ------
                guard let credential = auth.credential as? ASAuthorizationAppleIDCredential
                else {
                    print("Error with Firebase - Apple Login : GETTING CREDENTIAL")
                    return
                }
                loginData.authenticate(credential: credential, failHandler: failHandler)
                // ------ Firebase Login ------
                
                // if Firebase Login Successed.
                // MARK: AppleLoginViewModel - AppleLoginHandler쪽에 구현되어 있으나, userData(EnvironmentOB)를 업데이트하기 위함.
                user.AppleID = credential.user
                if let email = credential.email {
                    user.email = email
                    print("첫 로그인(회원가입) : \(user.email) email data saved.")
                } else {
                    print("로그인 - appleID ; \(user.AppleID)")
                    let userColRef = FirebaseManager.shared.getColRef(.User)
                    userColRef.whereField("AppleID", isEqualTo: user.AppleID)
                        .getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents - AppleLoginView[handle] : \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("Document ID: \(document.documentID)")
                                    if let idField = document.get("id") as? String {
                                        user.email = idField
                                        print("로그인(이미 가입된 회원) : \(user.email) - email data saved.")
                                    }
                                    if let nickName = document.get("nickName") as? String {
                                        user.nickName = nickName
                                        print("로그인(이미 가입된 회원) : \(user.nickName)")
                                    }
                                    if let babyName = document.get("babyName") as? String,
                                       let isAgreeToAdvertising = document.get("isAgreeToAdvertising") as? Bool,
                                       let babyBirthDate = (document.get("babyBirthDate") as? Timestamp)?.dateValue(),
                                       let solidStartDate = (document.get("solidStartDate") as? Timestamp)?.dateValue() {
                                        user.babyName = babyName
                                        user.isAgreeToAdvertising = isAgreeToAdvertising
                                        user.babyBirthDate = babyBirthDate
                                        user.solidStartDate = solidStartDate
                                        print("로그인(이미 가입된 회원) : 각종 User Data Fetched.")
                                    }
                                }
                            }
                        }
                }
                
            default:
                print(auth.credential)
            }
            
        case .failure(let err):
            print(">>> Handle Failure : ", err)
        }
    }
    
    // From Firebase Official Document...
    // Helpers for Apple Login with Firebase
    
    // SHA256 암호화
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // random Nonce String 리턴
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

