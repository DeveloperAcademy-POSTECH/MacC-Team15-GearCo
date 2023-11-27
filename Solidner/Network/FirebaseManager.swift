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
        case Plan
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

// MARK: MealOB 관련
extension FirebaseManager {
    /// MealOB 측에서 계획 데이터를 저장할 때 호출.
    /// - Parameters:
    ///   - mealData: MealOB 객체
    ///   - completion: Error Completion Handler.
    func saveMealPlan(_ mealData: MealOB, user: UserOB, completion: (Result<Void, Error>) -> Void) {
        let planColRef = getColRef(.Plan)
        let uuid = UUID().uuidString
        let planDocRefToSave = planColRef.document("\(user.email)_\(uuid)")
        
        let dataToSave: [String: Any] = [
            "email": user.email,
            "planID": uuid,
            "startDate": Timestamp(date: mealData.startDate),
            "endDate": Timestamp(date: mealData.endDate),
            "mealType": mealData.mealType?.rawValue ?? 0,
            "newIngredients": mealData.newIngredients.map { $0.id },
            "oldIngredients": mealData.oldIngredients.map { $0.id }
        ]
        
        planDocRefToSave.setData(dataToSave, merge: true) { err in
            if let err = err {
                print("MealPlan 저장 실패! - \(err)")
            } else {
                print("MealPlan 저장 완료. - \(user.email)_\(uuid)")
            }
        }
    }
}
