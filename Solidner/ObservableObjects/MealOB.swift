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
    @Published private(set) var tempNewIngredients: [Ingredient] = []
    @Published private(set) var tempOldIngredients: [Ingredient] = []
    @Published private(set) var mealType: MealType?
    @Published private(set) var startDate: Date
    @Published var cycleGap: CycleGaps
    
    var isAddButtonDisabled: Bool {
        mealPlan == nil && ((tempNewIngredients.count == 0 && tempOldIngredients.count == 0 ) || mealType == nil)
    }

    var endDate: Date {
        startDate.add(.day, value: cycleGap.rawValue - 1)
    }

    // Edit일 때 initializer
    init(mealPlan: MealPlan, cycleGap: CycleGaps) {
        self.mealPlan = mealPlan
        self.startDate = mealPlan.startDate
        self.tempNewIngredients = mealPlan.newIngredients
        self.tempOldIngredients = mealPlan.oldIngredients
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
            tempOldIngredients.removeAll { $0 == ingredient }
        case .new:
            tempNewIngredients.removeAll { $0 == ingredient }
        }
    }

    #warning("meal - add plan 구현하기")
    // TODO: add plan :) FB에 쓔우우웅?!
    func addMealPlan() {
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
