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
    @Published private(set) var mealPlans: [MealPlan] = [] {
        didSet {
            applyFilter()
        }
    }
    @Published private(set) var filteredMealPlans: [MealPlan] = []
    
    init(mealPlans: [MealPlan] = MealPlan.mockMealsTwo, 
         currentFilter: MealPlanFilter = .month(date:Date())) {
        #warning("meal plan 파베에서 받아오는 함수 구현해야 함")
        let sortedMealPlan = mealPlans.sorted { $0.startDate < $1.startDate }
        self.mealPlans = sortedMealPlan
        self.filteredMealPlans = sortedMealPlan
        self.currentFilter = currentFilter
        applyFilter()
    }
    
    // month 유저 설정 받아둘 필요가 있을까? -> AppStorage
    // 현재는 앱을 켜면 이번달을 먼저 보여줌
    // alex: 일단 이번달로 ㄱㄱ
    var currentFilter: MealPlanFilter = .month(date:Date()) {
        didSet {
            applyFilter()
        }
    }
    
    var mealPlanGroups: [MealPlanGroup] {
        get {
            MealPlanGroup.build(with: filteredMealPlans).sorted { $0.solidDate.startDate < $1.solidDate.startDate }
        }
    }
    
    var mealPlanGroup: MealPlanGroup? {
        get { MealPlanGroup.build(with: filteredMealPlans).first }
        set { updateMealPlan(in: newValue) }
    }
    
    func updateMealPlan(in group: MealPlanGroup?) {
        if let group { updatePlans(using: group.mealPlans) }
    }
    
    /// updatedItem을 순회하며 id를 기준으로 mealPlans를 업데이트 하는 함수
    /// - Parameter updatedItems: update 된 mealPlan들
    func updatePlans(using updatedItems: [MealPlan]) {
        let updatedItemsDictionary = updatedItems.reduce(into: [UUID:MealPlan]()) { partialRes, mealPlan in
            partialRes[mealPlan.id] = mealPlan
        }
        var tempMealPlans = mealPlans
        for i in 0..<tempMealPlans.count {
            if let newValue = updatedItemsDictionary[mealPlans[i].id] {
                tempMealPlans[i] = newValue
            }
        }
        mealPlans = tempMealPlans
    }
    
    /// date가 포함된 날짜의 모든 meal plan을 반환하는 함수
    /// - Parameter date: 원하는 날짜
    /// - Returns: date가 포함된 meal plan의 list
    func getMealPlans(in date: Date) -> [MealPlan] {
        mealPlans.filter {
            date.isInBetween(from: $0.startDate, to: $0.endDate)
        }
    }
    
    private func applyFilter() {
        switch currentFilter {
        case .all:
            filteredMealPlans = mealPlans
        case let .dateRange(start, end):
            filteredMealPlans = mealPlans.filter {
                start.isInBetween(from: $0.startDate, to: $0.endDate) || end.isInBetween(from: $0.startDate, to: $0.endDate)
            }
        case let .month(date):
            #warning("test해봐야...")
            filteredMealPlans = mealPlans.filter {
                let start = Date.date(year: date.year, month: date.month, day: 1) ?? Date()
                let end = start.add(.month, value: 1).add(.day, value: -1)
                return $0.startDate.isInBetween(from: start, to: end) || $0.endDate.isInBetween(from: start, to: end)
//                return ($0.startDate <= end && $0.startDate >= start) || ($0.endDate >= start && $0.endDate <= end)
            }
        case let .day(date):
            filteredMealPlans = mealPlans.filter {
                date.isInBetween(from: $0.startDate, to: $0.endDate)
            }
        }
    }
    
    
    #warning("플랜 전체 삭제 구현")
    func deleteAllPlans() {
        print(#function)
    }

    #warning("특정 달에 문제 있는 plan 날짜를 반환하는 함수")
        
}
