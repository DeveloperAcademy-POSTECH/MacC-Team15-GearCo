//
//  MealOB.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

import SwiftUI

final class MealOB: ObservableObject {
    // TODO: renaming 필요할듯
    @Published private(set) var testingIngredients: [Ingredient] = []
    @Published private(set) var testedIngredients: [Ingredient] = []
    @Published private(set) var mealType: MealType?
    @Published private(set) var startDate: Date
    // TODO: cycleGap은 default 값을 받아와야 합니다.
    @Published var cycleGap: CycleGaps = .three
    var endDate: Date {
        startDate.add(.day, value: cycleGap.rawValue - 1)
    }

    init(testingIngredients: [Ingredient] = Ingredient.mockTestingIngredients,
         testedIngredients: [Ingredient] = Ingredient.mockTestedIngredients,
         startDate: Date = Date()) {
        self.testingIngredients = testingIngredients
        self.testedIngredients = testedIngredients
        self.startDate = startDate
    }

    func set(mealType: MealType) {
        print(#function)
        withAnimation {
            self.mealType = mealType
        }
    }

    func set(startDate: Date) {
        withAnimation {
            self.startDate = startDate
        }
    }

    func delete(ingredient: Ingredient, in testType: IngredientTestType) {
        switch testType {
        case .tested:
            testedIngredients.removeAll { $0 == ingredient }
        case .testing:
            testingIngredients.removeAll { $0 == ingredient }
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
        case tested, testing
    }
}
