//
//  MealPlansOB.swift
//  Solidner
//
//  Created by sei on 11/26/23.
//

import SwiftUI

enum MealPlanFilter {
    case all
    case dateRange(start:Date, end: Date)
    // 해당 Date가 포함된 month로 필터링
    case month(date: Date)
    case day(date: Date)
}

final class MealPlansOB: ObservableObject {
    
    private let firebaseManager = FirebaseManager.shared
//    private var email: String = "jwlee010222@gmail.com"
    @AppStorage("email") private var email: String = "jwlee010222@gmail.com"
    
    @Published var isLoaded: Bool = false
    @Published private(set) var mealPlans: [MealPlan] = [] {
        didSet {
            applyFilter()
        }
    }
    @Published private(set) var filteredMealPlans: [MealPlan] = []
    
    init(currentFilter: MealPlanFilter = .month(date:Date())) {
        // View 측에서 task로 loadAllPlans() 호출 바람
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
    

    /// 앱 실행 시 (MealPlansOB Init 시) DB에서 모든 Plan 정보를 fetch.
    /// MealPlansOB 객체 초기화 이후 필수적으로 task로 호출해야 함.
    /// - Parameter user: UserOB의 객체.
    func loadAllPlans() async {
        let plans = await firebaseManager.loadAllPlans(email: email)
        await MainActor.run {
            self.mealPlans = plans
            self.isLoaded = true
        }
    }
    
    //MARK: - update
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
    
    func updateMealPlan(in group: MealPlanGroup?) {
        if let group { updatePlans(using: group.mealPlans) }
    }
    
    func update(plan: MealPlan) {
        var tempMealPlans: [MealPlan] = mealPlans
        tempMealPlans[plan] = plan
        mealPlans = tempMealPlans
    }
    
    func add(plan: MealPlan) {
        mealPlans = mealPlans + [plan]
    }
    
    /// date가 포함된 날짜의 모든 meal plan을 반환하는 함수
    /// - Parameter date: 원하는 날짜
    /// - Returns: date가 포함된 meal plan의 list
    func getMealPlans(in date: Date) -> [MealPlan] {
        mealPlans.filter {
            date.isInBetween(from: $0.startDate.dayOfStart, to: $0.endDate.dayOfEnd)
        }
    }
    
    func getMealPlans(from startDate: Date, to endDate: Date) -> [MealPlan] {
        mealPlans.filter {
            MealPlanGroup.SolidDate(startDate: $0.startDate, endDate: $0.endDate) == MealPlanGroup.SolidDate(startDate: startDate, endDate: endDate)
//            $0.startDate == startDate && $0.endDate == endDate
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
    
    //MARK: - delete
    #warning("플랜 전체 삭제 구현 - firebase에서도 구현 필요")
    func deleteAllPlans() {
        print(#function)
        mealPlans = []
    }
    
    func delete(plan: MealPlan) {
        mealPlans.remove(plan)
    }

    func getWrongPlanDates(date: Date) -> [DateAndPlanStatus] {
        let currentMonthMealPlans = getCurrentMonthMealPlans(of: date)
        return date.monthDates().map {
            DateAndPlanStatus(date: $0, isPlanWrong: isWrongPlan(at: $0, in: currentMonthMealPlans))
        }
    }
    
    private func getCurrentMonthMealPlans(of date: Date) -> [MealPlan] {
        let monthDates = date.monthDates()
        if let theFirstDay = monthDates.first, let theLastDay = monthDates.last {
             
            return mealPlans.filter {
                theFirstDay.isInBetween(from: $0.startDate, to: $0.endDate) ||
                $0.startDate >= theFirstDay && $0.endDate <= theLastDay ||
                theLastDay.isInBetween(from: $0.startDate, to: $0.endDate) }
        }
        return []
    }
    
    private func isWrongPlan(at date: Date, in plans: [MealPlan]) -> Bool {
        let relatedPlans = plans.filter { date.isInBetween(from: $0.startDate, to: $0.endDate) }
        
        return WrongPlanChecker.isWrongPlan(relatedPlans)
    }
}

struct DateAndPlanStatus: Identifiable {
    let date: Date
    let isPlanWrong: Bool
    
    var id: Date { date }
}
