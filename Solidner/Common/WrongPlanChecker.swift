//
//  WrongPlanChecker.swift
//  Solidner
//
//  Created by sei on 11/28/23.
//

import Foundation

enum WrongPlanChecker {
    
    /// 잘못된 plan인지 아닌지 체크하는 함수
    /// 1. 해당 Group에서 테스트 재료가 2개 초과인 경우
    /// 2. 6끼 이상인 경우
    /// 3. 중복되는 끼니가 있는 경우
    /// - Parameter meals: 체크하려는 meal Plan list
    /// - Returns: wrong일 시 true, 그렇지 않으면 false
    static func isWrongPlan(_ meals: [MealPlan]) -> Bool {
        // 1. 해당 Group에서 테스트 재료가 2개 초과인 경우
        //
        //
        return isTooMuchTestingIngredient(in: meals) || isTooMuch(mealPlans: meals) || occursDuplicatedMealType(in: meals)
    }
    
    private static func isTooMuchTestingIngredient(in mealPlans: [MealPlan]) -> Bool {
        Set(mealPlans.flatMap { $0.newIngredients }).count > 2
    }
    
    private static func isTooMuch(mealPlans: [MealPlan]) -> Bool {
        mealPlans.count >= 6
    }
    
    private static func occursDuplicatedMealType(in mealPlans: [MealPlan]) -> Bool {
        Set(mealPlans.map { $0.mealType }).count != mealPlans.count
    }
    
    
}
