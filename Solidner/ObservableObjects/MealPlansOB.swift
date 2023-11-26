//
//  MealPlansOB.swift
//  Solidner
//
//  Created by sei on 11/26/23.
//

import Foundation

enum MealPlanFilter {
    case all
    case dateRange(start:Date, end: Date)
    // 해당 Date가 포함된 month로 필터링
    case month(date: Date)
    case day(date: Date)
}

final class MealPlansOB: ObservableObject {
    // TODO: - init할 때 모든 플랜을 서버에서 갖고 와요.
    @Published private(set) var mealPlans: [MealPlan] = MealPlan.mockMealsOne
    @Published private(set) var filteredMealPlans: [MealPlan] = []
    var mealPlanGroups: [MealPlanGroup] { MealPlanGroup.build(with: filteredMealPlans) }
    
    init(mealPlans: [MealPlan] = MealPlan.mockMealsOne, currentFilter: MealPlanFilter = .all) {
        self.mealPlans = mealPlans
        self.filteredMealPlans = mealPlans
        self.currentFilter = currentFilter
    }
    
    var currentFilter: MealPlanFilter = .all {
        didSet {
            applyFilter()
        }
    }
    
    private func applyFilter() {
        switch currentFilter {
        case .all:
            filteredMealPlans = mealPlans
        case let .dateRange(start, end):
            filteredMealPlans = mealPlans.filter {
                start.isInBetween(from: $0.startDate, to: $0.endDate) || end.isInBetween(from: $0.startDate, to: $0.endDate)
//                ($0.startDate <= end && $0.startDate >= start) || ($0.endDate >= start && $0.endDate <= end)
            }
        case let .month(date):
            filteredMealPlans = mealPlans.filter {
                let start = Date.date(year: date.year, month: date.month, day: 1) ?? Date()
                let end = start.add(.month, value: 1).add(.day, value: -1)
                return ($0.startDate <= end && $0.startDate >= start) || ($0.endDate >= start && $0.endDate <= end)
            }
        case let .day(date):
            filteredMealPlans = mealPlans.filter {
                date.isInBetween(from: $0.startDate, to: $0.endDate)
            }
        }
    }

    // 1. 특정 달에 문제 있는 plan을
        
}
