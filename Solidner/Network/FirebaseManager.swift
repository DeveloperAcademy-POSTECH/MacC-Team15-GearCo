//
//  FirebaseManager.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/08.
//

import SwiftUI
import Firebase

final class FirebaseManager {
    enum CollectionName: String {
        case User
        case Plan
    }
    
    static let shared = FirebaseManager()
    #warning("ingredientData의 fetch가 선행되어야 함. 나중에 비동기로 순차 처리 되도록 주의할 것.")
    let ingredientData = IngredientData.shared.ingredients
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

// MARK: MealPlansOB 관련
extension FirebaseManager {
    
    func loadAllPlans(email: String) -> [MealPlan] {
        var result: [MealPlan] = []
        let planColRef = getColRef(.Plan)
        
        func parseDataToMealPlan(data: [String: Any]) -> MealPlan {
            let id = UUID(uuidString: data["planID"] as? String ?? "") ?? UUID()
            let startDate = (data["startDate"] as? Timestamp ?? Timestamp()).dateValue()
            let endDate = (data["endDate"] as? Timestamp ?? Timestamp()).dateValue()
            let mealType = MealType(rawValue: data["mealType"] as? Int ?? 0) ?? .아침
            var newIngredients: [Ingredient] {
                var res: [Ingredient] = []
                let newIngredientIDs = data["newIngredients"] as? [Int] ?? []
                
                for id in newIngredientIDs {
                    if let ingredient = ingredientData[id] {
                        res.append(ingredient)
                    }
                }
                return res
            }
            var oldIngredients: [Ingredient] {
                var res: [Ingredient] = []
                let oldIngredientIDs = data["oldIngredients"] as? [Int] ?? []
                
                for id in oldIngredientIDs {
                    if let ingredient = ingredientData[id] {
                        res.append(ingredient)
                    }
                }
                return res
            }
            
            return MealPlan(id: id, startDate: startDate, endDate: endDate, mealType: mealType, newIngredients: newIngredients, oldIngredients: oldIngredients)
        }
        
        planColRef.whereField("email", isEqualTo: email).getDocuments { querySnapshot, err in
            if let err {
                print("MealPlansOB 초기화 실패! 모든 계획을 성공적으로 불러오지 못했습니다. - \(err)")
            } else {
                if let querySnapshot {
                    for document in querySnapshot.documents {
                        result.append(parseDataToMealPlan(data: document.data()))
                    }
                    print("MealPlansOB 초기화 - 모든 계획을 불러오는 데 성공했습니다.")
                } else {
                    print("MealPlansOB 초기화 - 아직 생성한 계획이 없거나, 계획을 모두 불러오는 데 실패했습니다.")
                }
            }
        }
        return result
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
