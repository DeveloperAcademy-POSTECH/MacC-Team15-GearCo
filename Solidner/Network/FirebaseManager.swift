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

extension CollectionReference {
    func getDocRef(_ email: String, id: String?) -> DocumentReference {
        if let id {
            return self.document("\(email)_\(id)")
        }
        return self.document("\(email)")
    }
}

// MARK: MealOB 관련
extension FirebaseManager {
    /// MealOB 측에서 계획 데이터를 저장할 때 호출.
    /// MealPlan 데이터를 넣지 않고 MealOB만 넣으면 save, MealPlan 데이터를 넣으면 update로 작동합니다.
    /// - Parameters:
    ///   - mealData: MealOB 객체
    ///   - completion: Error Completion Handler.
    func saveMealPlan(_ mealData: MealOB, mealPlan: MealPlan? = nil, user: UserOB) {
        let planColRef = getColRef(.Plan)
        var uuid: String {
            if let mealPlan {
                return mealPlan.id.uuidString
            }
            return UUID().uuidString
        }
        let planDocRefToSave = planColRef.getDocRef(user.email, id: uuid)
        
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
    
    func deleteMealPlan(_ mealPlan: MealPlan?, user: UserOB) {
        if let mealPlan {
            let planDocRef = getColRef(.Plan).getDocRef(user.email, id: mealPlan.id.uuidString)
            
            planDocRef.delete { err in
                if let err = err {
                    print("MealPlan 삭제 실패 - \(err)")
                } else {
                    print("MealPlan 삭제 완료. - \(user.email)_\(mealPlan.id.uuidString)")
                }
            }
        } else {
            print("MealPlan 삭제 실패 - 계획이 정상적으로 존재하지 않는 상태입니다.")
        }
    }
}
