//
//  MealOB.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI

final class MealOB: ObservableObject {
    let mealPlan: MealPlan
    // TODO: renaming 필요할듯
    @Published private(set) var tempMealPlan: MealPlan
//    @Published private(set) var tempNewIngredients: [Ingredient] = []
//    @Published private(set) var testedIngredients: [Ingredient] = []
//    @Published private(set) var mealType: MealType?
//    @Published private(set) var startDate: Date
//    // TODO: cycleGap은 default 값을 받아와야 합니다.
    @Published var cycleGap: CycleGaps = .three {
        willSet {
            tempMealPlan.cycleGap = newValue
        }
    }

    var endDate: Date {
        tempMealPlan.endDate
    }

    init(mealPlan: MealPlan) {
        self.mealPlan = mealPlan
        self.tempMealPlan = mealPlan
        self.cycleGap = mealPlan.cycleGap
    }

//    init(testingIngredients: [Ingredient] = Ingredient.mockTestingIngredients,
//         testedIngredients: [Ingredient] = Ingredient.mockTestedIngredients,
//         startDate: Date = Date()) {
//        self.tempNewIngredients = testingIngredients
//        self.testedIngredients = testedIngredients
//        self.startDate = startDate
//    }

    func set(mealType: MealType) {
        print(#function)
        withAnimation {
//            self.mealType = mealType
            self.tempMealPlan.set(mealType: mealType)
        }
    }

    func set(startDate date: Date) {
        withAnimation {
//            self.startDate = startDate
            tempMealPlan.set(startDate: date)
            
        }
    }

    func delete(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
//            case .old:
//                testedIngredients.removeAll { $0 == ingredient }
//            case .new:
//                testingIngredients.removeAll { $0 == ingredient }
        case .old:
            tempMealPlan.remove(oldIngredient: ingredient)
        case .new:
            tempMealPlan.remove(newIngredient: ingredient)
        }
    }

    // TODO: add plan :) FB에 쓔우우웅?!
    func addMealPlan() {
        print(#function)
    }

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
