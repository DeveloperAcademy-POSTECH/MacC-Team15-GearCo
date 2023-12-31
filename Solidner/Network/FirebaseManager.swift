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
        case Report = "IngredientReport"
        case Count = "IngredientUseCount"
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

// MARK: 유저 관련
extension FirebaseManager {
    func createUser(_ userInfo: TempUserInfo, email: String) async throws {
        let dataToSave: [String: Any] = [
            "nickName": userInfo.nickName,
            "babyName": userInfo.babyName,
            "isAgreeToAdvertising": userInfo.isAgreeToAdvertising,
            "babyBirthDate": Timestamp(date: userInfo.babyBirthDate),
            "solidStartDate": Timestamp(date: userInfo.solidStartDate)
        ]
        
        let colRef = getColRef(.User)
        let docRef = colRef.getDocRef(email)
        
        do {
            try await docRef.setData(dataToSave, merge: true)
            print("온보딩 유저 데이터를 저장했습니다. - id: \(email)")
        } catch {
            print("온보딩 유저 데이터 저장에 실패했습니다.")
            throw error
        }
    }
    
    // TODO: 추후 회원탈퇴 로직 수정 (plan 제거, revoke 등)
    func withdrawUser(_ email: String) async throws {
        let colRef = getColRef(.User)
        let docRef = colRef.getDocRef(email)
        
        do {
            try await docRef.delete()
            print("유저 정보 삭제 완료 - email: \(email)")
        } catch {
            print("유저 정보 삭제에 실패했습니다. 재시도 해 주세요.")
            throw error
        }
    }
    
    func updateUser(_ email: String, nickName: String, babyName: String, babyBirth: Date, solidStart: Date) async throws {
        let colRef = getColRef(.User)
        let docRef = colRef.getDocRef(email)
        
        let dataToUpdate: [String: Any] = [
            "nickName": nickName,
            "babyName": babyName,
            "babyBirthDate": Timestamp(date: babyBirth),
            "solidStartDate": Timestamp(date: solidStart)
        ]
        
        do {
            try await docRef.setData(dataToUpdate, merge: true)
            print("회원 정보를 수정했습니다. - id: \(email)")
        } catch {
            print("회원 정보 수정에 실패했습니다.")
            throw error
        }
    }
}

// MARK: 없는 재료 리포트
extension FirebaseManager {
    
    func reportIngredient(note: String, replyEmail: String, userEmail: String) async {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYMMddHHmmss"
        let formattedDate = dateFormatter.string(from: nowDate)
        
        let colRef = getColRef(.Report)
        let docRef = colRef.getDocRef(userEmail, id: formattedDate)
        
        let dataToSave: [String: Any] = [
            "email": userEmail,
            "emailToReply": replyEmail,
            "note": note,
            "date": Timestamp(date: nowDate)
        ]
        
        do {
            try await docRef.setData(dataToSave)
            print("재료 신고를 완료했습니다 - id: \(userEmail)_\(formattedDate)")
        } catch {
            print("재료 신고에 실패했습니다. 재시도 바랍니다.")
        }
    }
}

// MARK: MealPlansOB 관련
extension FirebaseManager {
    
    func loadAllPlans(email: String) async -> [MealPlan] {
        var result: [MealPlan] = []
        let planColRef = getColRef(.Plan)
        
        do {
            let querySnapshot = try await planColRef.whereField("email", isEqualTo: email).getDocumentsAsync()
            for document in querySnapshot.documents {
                result.append(parseDataToMealPlan(data: document.data()))
            }
            print("MealPlansOB 초기화 - 모든 계획을 불러오는 데 성공했습니다.")
        } catch {
            print("MealPlansOB 초기화 실패! 모든 계획을 성공적으로 불러오지 못했습니다. - \(error)")
        }
        
        return result
        
        // func to parse querydata to MealPlan object.
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
    }
}

// MARK: MealOB 관련
extension FirebaseManager {
    /// MealOB 측에서 계획 데이터를 저장할 때 호출.
    /// MealPlan 데이터를 넣지 않고 MealOB만 넣으면 save, MealPlan 데이터를 넣으면 update로 작동합니다.
    /// - Parameters:
    ///   - mealData: MealOB 객체
    ///   - mealPlan:
    ///     - nil일 때 - 함수는 새로운 mealPlan을 생성 후 저장한다.
    ///     - nil이 아닐 때, 수정하려는 meal Plan
    ///   - user: UserOB 객체
    /// - Returns: 새롭게 생성된 플랜의 UUID / 기존 플랜의 id
    @discardableResult
    func saveMealPlan(_ mealData: MealOB, mealPlan: MealPlan? = nil, user: UserOB) -> UUID {
        let planColRef = getColRef(.Plan)
        let uuid: UUID = {
            if let mealPlan {
                return mealPlan.id
            }
            return UUID()
        }()
        let uuidString = uuid.uuidString
        let planDocRefToSave = planColRef.getDocRef(user.email, id: uuidString)
        
        let dataToSave: [String: Any] = [
            "email": user.email,
            "planID": uuidString,
            "startDate": Timestamp(date: mealData.startDate),
            "endDate": Timestamp(date: mealData.endDate),
            "mealType": mealData.mealType?.rawValue ?? 0,
            "newIngredients": mealData.newIngredients.map { $0.id },
            "oldIngredients": mealData.oldIngredients.map { $0.id }
        ]
        
        planDocRefToSave.setData(dataToSave, merge: true) { err in
            if let err = err {
                print("MealPlan 저장&수정 실패! - \(err)")
            } else {
                print("MealPlan 저장 완료. - \(user.email)_\(uuidString)")
            }
        }
        return uuid
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
    
    func deleteAllMealPlan(email: String) async throws {
        let planColRef = getColRef(.Plan)
        
        // 'idField' 필드에 특정 문자열을 포함하는 문서 검색
        let querySnapshot = try await planColRef.whereField("email", isEqualTo: email).getDocumentsAsync()
        // Batch를 생성하여 검색된 문서들 삭제
        let batch = db.batch()
        for document in querySnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        try await batch.commit()
    }
}

//extension FirebaseManager {
//    enum CountUpdateCase {
//        case add
//        case delete
//        case update
//    }
//    
//    func updateIngredientUseCount(mealData: MealOB? = nil, mealPlan: MealPlan? = nil, email: String, updateCase: CountUpdateCase) async {
//        let colRef = getColRef(.Count)
//        let docRef = colRef.getDocRef(email)
//        
//        switch updateCase {
//        case .add:
//            let dataToSave: [String: Any]
//            for ingredient in mealData
//        case .delete:
//            <#code#>
//        case .update:
//            <#code#>
//        }
//    }
//}
