//
//  AppleLoginOB.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI
import AuthenticationServices
import Firebase
import FirebaseAuth

class AppleLoginOB: ObservableObject{
    @EnvironmentObject var user: UserOB
    @AppStorage("email") var email = ""
    
    // State of Signed in
    enum SignInState {
        case signedIn
        case signedOut
    }
    @Published var state: SignInState = .signedOut
    
    // LoginView - func configure
    @Published var nonce = ""
    
    func authenticate(credential: ASAuthorizationAppleIDCredential, failHandler : @escaping (String,String) -> Void ){
        print("authenticate 시작")
        // get Token
        guard let token = credential.identityToken else{
            print("Error with Firebase - Apple Login : GETTING TOKEN")
            failHandler("토큰 획득 실패!","다시 시도해주세요")
            return
        }
        
        // Token String
        guard let tokenString = String(data: token, encoding: .utf8) else{
            print("Error with Firebase - Apple Login : In Token Parsing to String")
            failHandler("토큰 파싱 실패!","다시 시도해주세요")
            return
        }
        
        // MARK: 추후 회원 탈퇴 기능 추가 시 참고
        // authorization Code to Unregister! => get user authorizationCode when login.
//        if let authorizationCode = credential.authorizationCode, let codeString = String(data: authorizationCode, encoding: .utf8) {
//            print("authorizationCode :: ", codeString)
//            let url = URL(string: "https://us-central1-atarashii2-fa9ec.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
//            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
//                if let data = data {
//                    let refreshToken = String(data: data, encoding: .utf8) ?? ""
//                    print("refreshToken :: ", refreshToken)
//                    // TODO: *For security reasons, we recommend iCloud keychain rather than UserDefaults.
//                    UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
//                    UserDefaults.standard.synchronize()
//                }
//                if let error = error {
//                    print("Error on get Refresh Token :: \(error)")
//                }
//            }
//            task.resume()
//        }
        
        // Initialize a Firebase credential.
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: tokenString, rawNonce: nonce)
        // Sign in with Firebase.
        Auth.auth().signIn(with: firebaseCredential) { (result, err) in
            if let error = err {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print(error.localizedDescription)
                failHandler("Auth 인증 실패", "다시 시도해주세요")
                return
            }
            
            // User is signed in to Firebase with Apple.
            // ...
            print("Firebase - Apple Login : Logged In Successfully")
                        
            // 로그인 후처리 - 회원가입 창으로 넘기기 or 로그인 시 앱 실행
            // 애플 로그인은 최초 회원가입 이후 user Email을 제공하지 않으므로, 유저 고유 key를 가지고 접근해야 함.
            let userID : String = credential.user
            let useremail : String = credential.email ?? ""
                        
            if (useremail != ""){ // 최초 register
                print("Sign in With Apple : Register, upload User Data on Firestore")
                let userDocRef = FirebaseManager.shared.getUserDocRefWithEmail(useremail)
                userDocRef.setData([
                    "email" : useremail,
                    "AppleID" : userID,
                ], merge: true){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        failHandler("키페어 저장 실패", "다시시도해주세요")
                    } else {
                        print("Document successfully written!")
                        self.findUserHandler(userID, failHandler)
                    }
                }
            } else { //최초 register가 아닌 경우
                self.findUserHandler(userID, failHandler)
            }
        }
    }
    
    func findUserHandler(_ userID : String, _ failHandler : @escaping (String,String) -> Void){
        print("user 검색. \(userID)")
        let userColRef = FirebaseManager.shared.getColRef(.User)
        userColRef.whereField("AppleID", isEqualTo: userID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    failHandler("유저 확인 실패","다시 시도해주세요")
                } else {
                    // 최초 등록이 되지 않은 경우
                    if(querySnapshot!.isEmpty){
                        failHandler("최초 등록 실패","관리자 문의 바랍니다")
                    }else{
                        for document in querySnapshot!.documents {
                            let useremail = document.data()["email"] as? String ?? ""
                            print("Success fetching Email Data from Firebase in Apple Login")
                            self.appleLoginHandler(true, useremail, failHandler: failHandler)
                        }
                    }
                }
            }
    }
    
    func appleLoginHandler(_ result : Bool ,_ useremail : String, failHandler : @escaping (String,String) -> Void){
        // 애플로그인
        print("User Data Fetching - appleLoginHandler : \(useremail)")
        let userDocRef = FirebaseManager.shared.getUserDocRefWithEmail(useremail)
        userDocRef.getDocument { (snap, err) in
            if let snap = snap, snap.exists {
                if let err = err {
                    print(err.localizedDescription)
                    failHandler("유저 정보 조회 실패", "다시 시도해주세요")
                    return
                }
                guard let dict = snap.data() else { return }
                let userItems = dict
                
                let AppldID = userItems["AppleID"] as? String ?? ""
                let email = userItems["email"] as? String ?? ""
                let nickName = userItems["nickName"] as? String ?? ""
                let babyName = userItems["babyName"] as? String ?? ""
                let isAgreeToAdvertising = userItems["isAgreeToAdvertising"] as? Bool ?? false
                let babyBirthDate = (userItems["babyBirthDate"] as? Timestamp ?? Timestamp(date: Date())).dateValue()
                let solidStartDate = (userItems["solidStartDate"] as? Timestamp ?? Timestamp(date: Date())).dateValue()
                
                
                UserDefaults().set(email, forKey: "email")
                UserDefaults().set(AppldID, forKey: "AppleID")
                UserDefaults().set(babyName, forKey: "babyName")
                UserDefaults().set(nickName, forKey: "nickName")
                UserDefaults().set(isAgreeToAdvertising, forKey: "isAgreeToAdvertising")
                UserDefaults().set(babyBirthDate, forKey: "babyBirthDate")
                UserDefaults().set(solidStartDate, forKey: "solidStartDate")
                
                print("Uset Data Fetched, saved at UserDefaults.")
            }
        }
    }
}
