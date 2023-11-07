//
//  FirebaseManager.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI
import Firebase

class FirebaseManager {
    enum CollectionName: String {
        case User
    }
    
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    private init() {}
    
    func getColRef(_ collectionName: CollectionName) -> CollectionReference {
        return db.collection(collectionName.rawValue)
    }
    
    func getUserDocRefWithEmail(_ email: String) -> DocumentReference {
        return db.collection(CollectionName.User.rawValue).document(email)
    }
}
