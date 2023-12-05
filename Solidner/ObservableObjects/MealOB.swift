//
//  MealOB.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI
import Algorithms

final class MealOB: ObservableObject {
//    static let mock: MealOB = MealOB(mealPlan: MealPlan.mockMealsOne.first!, cycleGap: .three)
    
    let mealPlan: MealPlan?
    weak var mealPlansOB: MealPlansOB?
    
    @Published private(set) var newIngredients: [Ingredient] = [] {
        didSet {
            mismatches = buildMismatches()
        }
    }
    @Published private(set) var oldIngredients: [Ingredient] = [] {
        didSet {
            mismatches = buildMismatches()
        }
    }
    @Published private(set) var mealType: MealType?
    @Published private(set) var startDate: Date
    @Published var cycleGap: CycleGaps
    
    private let firebaseManager = FirebaseManager.shared
    
    var isAddButtonDisabled: Bool {
        mealPlan == nil && ((newIngredients.count == 0 && oldIngredients.count == 0 ) || mealType == nil)
    }

    var endDate: Date {
        startDate.add(.day, value: cycleGap.rawValue - 1)
    }

    // Edit일 때 initializer
    init(mealPlan: MealPlan, cycleGap: CycleGaps, mealPlansOB: MealPlansOB) {
        self.mealPlan = mealPlan
        self.startDate = mealPlan.startDate
        self.newIngredients = mealPlan.newIngredients
        self.oldIngredients = mealPlan.oldIngredients
        self.mealType = mealPlan.mealType
        self.cycleGap = mealPlan.cycleGap
        self.mealPlansOB = mealPlansOB
    }
    
    // Add일 때 initializer
    init(startDate: Date, cycleGap: CycleGaps, mealPlansOB: MealPlansOB) {
        self.mealPlan = nil
        self.startDate = startDate
        self.mealType = nil
        self.cycleGap = cycleGap
        self.mealPlansOB = mealPlansOB
    }

    func set(mealType: MealType) {
        withAnimation {
            self.mealType = mealType
        }
    }

    func set(startDate date: Date) {
        withAnimation {
            self.startDate = date
        }
    }

    func delete(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .old:
            oldIngredients.remove(ingredient)
        case .new:
            newIngredients.remove(ingredient)
        }
    }
    
    func clearIngredient(in testType: IngredientTestType) {
        switch testType {
        case .old:
            oldIngredients = []
        case .new:
            newIngredients = []
        }
    }
    
    func selectIngredient(_ ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .old:
            if oldIngredients.contains(ingredient) {
                oldIngredients.remove(ingredient)
            } else {
                oldIngredients.append(ingredient)
            }
        case .new:
            if newIngredients.contains(ingredient) {
                newIngredients.remove(ingredient)
            } else {
                newIngredients.append(ingredient)
            }
        }
    }
    
    func addIngredient(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .old:
            oldIngredients.append(ingredient)
        case .new:
            newIngredients.append(ingredient)
        }
    }
    
    func addMealPlan(user: UserOB) {
        // DB 업데이트
        let id = firebaseManager.saveMealPlan(self, user: user)
        // mealPlans 업데이트
        if let mealPlan = makeNewMealPlan(id: id) {
            mealPlansOB?.add(plan: mealPlan)
        }
    }
    
    /// 입력받은 id를 바탕으로 현재 MealOB의 프로퍼티를 가진 MealPlan을 만듭니다.
    /// - Parameter id: 새로 생길 MealPlan의 id
    /// - Returns: MealPlan, id는 argument, 다른 프로퍼티는 MealOB의 프로퍼티.
    private func makeNewMealPlan(id: UUID) -> MealPlan? {
        if let mealType {
            return MealPlan(id: id,
                     startDate: startDate,
                     endDate: endDate,
                     mealType: mealType,
                     newIngredients: newIngredients,
                     oldIngredients: oldIngredients
            )
        }
        return nil
    }

    func changeMealPlan(user: UserOB) {
        // MealPlansOB 업데이트
        if let mealPlan, let newMealPlan = makeNewMealPlan(id: mealPlan.id) {
            mealPlansOB?.update(plan: newMealPlan)
        }
        // DB 업데이트
        firebaseManager.saveMealPlan(self, mealPlan: self.mealPlan, user: user)
    }
    
    func deleteMealPlan(user: UserOB) {
        // MealPlansOB 업데이트
        if let mealPlan {
            mealPlansOB?.delete(plan: mealPlan)
        }
        // DB 업데이트
        firebaseManager.deleteMealPlan(self.mealPlan, user: user)
    }
    
    lazy var mismatches: [Ingredient] = {
        return buildMismatches()
    }()
    
    private func buildMismatches() -> [Ingredient] {
        let totalMismatches = oldIngredients.flatMap { $0.misMatches } + newIngredients.flatMap { $0.misMatches }
        return Array(totalMismatches.uniqued())
    }
}

extension MealOB {
    enum IngredientTestType {
        case old, new
    }
}
