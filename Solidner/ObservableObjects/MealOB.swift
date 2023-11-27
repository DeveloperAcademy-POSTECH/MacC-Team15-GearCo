//
//  MealOB.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI

final class MealOB: ObservableObject {
    static let mock: MealOB = MealOB(mealPlan: MealPlan.mockMealsOne.first!, cycleGap: .three)
    
    let mealPlan: MealPlan?
    @Published private(set) var newIngredients: [Ingredient] = []
    @Published private(set) var oldIngredients: [Ingredient] = []
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
    init(mealPlan: MealPlan, cycleGap: CycleGaps) {
        self.mealPlan = mealPlan
        self.startDate = mealPlan.startDate
        self.newIngredients = mealPlan.newIngredients
        self.oldIngredients = mealPlan.oldIngredients
        self.mealType = mealPlan.mealType
        self.cycleGap = mealPlan.cycleGap
    }
    
    // Add일 때 initializer
    init(startDate: Date, cycleGap: CycleGaps) {
        self.mealPlan = nil
        self.startDate = startDate
        self.mealType = nil
        self.cycleGap = cycleGap
    }

    func set(mealType: MealType) {
        print(#function)
        withAnimation {
            self.mealType = mealType
        }
    }

    func set(startDate date: Date) {
        withAnimation {
            print(#function)
            self.startDate = date
        }
    }

    func delete(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .old:
            oldIngredients.removeAll { $0 == ingredient }
        case .new:
            newIngredients.removeAll { $0 == ingredient }
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
    func addIngredient(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .old:
            oldIngredients.append(ingredient)
        case .new:
            newIngredients.append(ingredient)
        }
    }

    #warning("meal - add plan 구현하기")
    // TODO: add plan :) FB에 쓔우우웅?! + mealPlans에도 넣어야?!
    func addMealPlan(user: UserOB) {
        firebaseManager.saveMealPlan(self, user: user) { result in
            switch result {
            case .success:
                print("식단 계획이 성공적으로 저장되었습니다.")
            case .failure(let error):
                print("오류 발생: \(error.localizedDescription)")
            }
        }
    }
    
    #warning("meal - change plan 구현하기")
    // TODO: change plan :) FB에 쓔우우웅?!
    func changeMealPlan() {
        print(#function)
    }
    
    #warning("meal - delete plan 구현하기")
    // TODO: delete plan :) FB에 쓔우우웅?!
    func deleteMealPlan() {
        print(#function)
    }
}

extension MealOB {
    enum IngredientTestType {
        case old, new
    }
}
