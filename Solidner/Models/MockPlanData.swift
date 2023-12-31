//
//  MockPlanData.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MealPlanGroup: Hashable {
    var solidDate: SolidDate
    var mealPlans: [MealPlan]
    var sortedMealPlans: [MealPlan] {
        mealPlans.sorted { $0.mealType < $1.mealType }
    }

    init(solidDate: SolidDate, mealPlans: [MealPlan]) {
        self.solidDate = solidDate
        self.mealPlans = mealPlans
    }
    
    var isWrong: Bool {
        // 1. 해당 Group에서 테스트 재료가 2개 초과인 경우
        // 2. 6끼 이상인 경우
        // 3. 중복되는 끼니가 있는 경우
        WrongPlanChecker.isWrongPlan(mealPlans)
    }
}

extension MealPlanGroup {
    init(startDate: Date = Date(), endDate: Date = Date(), mealPlans: [MealPlan] = []) {
        self.solidDate = .init(startDate: startDate, endDate: endDate)
        self.mealPlans = mealPlans
    }
}

extension MealPlanGroup {
    static func build(with mealPlans: [MealPlan]) -> [MealPlanGroup] {
        let mealsDict = Dictionary(grouping: mealPlans) { SolidDate(startDate: $0.startDate, endDate: $0.endDate) }
        return mealsDict.reduce(into: [MealPlanGroup]()) { partialResult, element in
            let (solidDate, mealPlans) = element
            partialResult.append(MealPlanGroup(solidDate: solidDate, mealPlans: mealPlans.sorted { $0.mealType < $1.mealType }))
        }
        .sorted { mealPlanGroup1, mealPlanGroup2 in
            // 시작일, 끼니 종류 기준
            mealPlanGroup1.solidDate.startDate < mealPlanGroup2.solidDate.startDate &&
            (mealPlanGroup1.mealPlans.first?.mealType) ?? MealType.간식2 < (mealPlanGroup2.mealPlans.first?.mealType) ?? MealType.간식2 &&
            mealPlanGroup1.solidDate.endDate < mealPlanGroup2.solidDate.endDate
        }
    }
}

extension MealPlanGroup {
    struct SolidDate: Hashable, Equatable {
        let startDate: Date
        let endDate: Date

        var description: String {
            TextLiterals.PlanList.dateRangeString(start: startDate, end: endDate)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(startDate.year)
            hasher.combine(startDate.month)
            hasher.combine(startDate.day)
            hasher.combine(endDate.year)
            hasher.combine(endDate.month)
            hasher.combine(endDate.day)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            // 비교하려는 
            let comparingComponents: [Calendar.Component] = [.year, .month, .day]
            return comparingComponents.allSatisfy { component in
                return (lhs.startDate.getValue(of: component) == rhs.startDate.getValue(of: component) &&
                        lhs.endDate.getValue(of: component) == rhs.endDate.getValue(of: component))
            }
        }
    }
}

struct MealPlan: Identifiable, Hashable {
    var id: UUID
    var startDate: Date {
        willSet {
            endDate = newValue.add(.day, value: cycleGap.rawValue - 1)
        }
    }
    var endDate: Date
    var mealType: MealType
    var newIngredients: [Ingredient]
    var oldIngredients: [Ingredient]
    var cycleGap: CycleGaps {
        get {
            CycleGaps(rawValue: Date.componentsBetweenDates(from: startDate, to: endDate).day! + 1)!
        }
        set {
            endDate = startDate.add(.day, value: newValue.rawValue - 1)
        }
    }
    
    init(id: UUID, startDate: Date, endDate: Date, mealType: MealType, newIngredients: [Ingredient], oldIngredients: [Ingredient]) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.mealType = mealType
        self.newIngredients = newIngredients
        self.oldIngredients = oldIngredients
    }
    
//    init(startDate: Date, endDate: Date) {
//        self.id = UUID()
//        self.startDate = startDate
//        self.endDate = endDate
//        self.mealType = .아침
//        self.newIngredients = []
//        self.oldIngredients = []
//    }

    var dateString: String {
        "\(startDate.day)일(\(startDate.weekDayKor)) ~ \(endDate.day)일(\(endDate.weekDayKor))"
    }

    var ingredientsString: String {
        oldIngredients.map { $0.description }.joined(separator: ", ")
    }
}

// Draggable을 위한
extension MealPlan: Codable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .mealPlan)
    }
}


extension UTType {
    static var mealPlan: UTType { UTType(exportedAs: "co.gear.mealPlan") }
}


extension MealPlan {
    mutating func set(mealType: MealType) {
        self.mealType = mealType
    }

    mutating func set(startDate: Date) {
        self.startDate = startDate
    }

    mutating func remove(newIngredient ingredient: Ingredient) {
        newIngredients.remove(ingredient)
    }

    mutating func remove(oldIngredient ingredient: Ingredient) {
        oldIngredients.remove(ingredient)
    }
}

enum MealType: Int, CaseIterable, Codable {
    case 아침, 점심, 저녁, 간식1, 간식2, 기타

    var description: String {
        switch self {
        case .아침:
            return "아침"
        case .점심:
            return "점심"
        case .저녁:
            return "저녁"
        case .간식1:
            return "간식1"
        case .간식2:
            return "간식2"
        case .기타:
            return "기타"
        }
    }

    var icon: String {
        switch self {
        case .아침:
            return "morning"
        case .점심:
            return "lunch"
        case .저녁:
            return "dinner"
        case .간식1:
            return "snack"
        case .간식2:
            return "snack"
        case .기타:
            return "etc"
        }
    }
}

extension MealType: Comparable {
    static func < (lhs: MealType, rhs: MealType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
//
//struct MockIngredient: CustomStringConvertible, Identifiable, Hashable, Codable {
//    private(set) var id = UUID()
//    let type: IngredientType
//    private(set) var ableMonth: Int = 6
//    private(set) var misMatches: [Ingredient] = []
//    private(set) var alternatives: [Ingredient] = []
//
//    var description: String { name }
//    var name: String
//
//    func setMisMatches(ingredients: [Ingredient]) -> Self {
//        var _self = self
//        _self.misMatches = ingredients
//        return _self
//    }
//}

//enum IngredientType: Codable {
//    case 곡물, 어육류, 노란채소, 채소, 과일, 유제품, 기타채소, 기타
//
//    var color: Color {
//        switch self {
//        case .곡물:
//            return .grain
//        case .어육류:
//            return .greenVegitable
//        case .노란채소:
//            return .yellowVegitable
//        case .녹색채소:
//            return .greenVegitable
//        case .과일:
//            return .fruit
//        case .유제품:
//            return .dairy
//        case .기타채소:
//            return .etcVegitable
//        case .기타:
//            return .etcIngredient
//        }
//    }
//}


//extension MealPlan {
//    static var mockMealsOne: [MealPlan] {
//        let ingredient = Ingredient.Mock.self
//        return [
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 14)!,
//                endDate: Date.date(year: 2023, month: 11, day: 16)!,
//                mealType: .아침,
//                newIngredients: [ingredient.소고기, ingredient.당근],
//                oldIngredients: [ingredient.쌀]
//            ),
//            // 2nd
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 17)!,
//                endDate: Date.date(year: 2023, month: 11, day: 20)!,
//                mealType: .아침,
//                newIngredients: [ingredient.쌀],
//                oldIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 17)!,
//                endDate: Date.date(year: 2023, month: 11, day: 20)!,
//                mealType: .점심,
//                newIngredients: [],
//                oldIngredients: [ingredient.쌀, ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 17)!,
//                endDate: Date.date(year: 2023, month: 11, day: 20)!,
//                mealType: .저녁,
//                newIngredients: [ingredient.땅콩],
//                oldIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
//            ),
//            // 3rd 21~24
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .아침,
//                newIngredients: [ingredient.쌀],
//                oldIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .점심,
//                newIngredients: [ingredient.쌀],
//                oldIngredients: [ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .저녁,
//                newIngredients: [],
//                oldIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .간식1,
//                newIngredients: [],
//                oldIngredients: [ingredient.단호박]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .간식2,
//                newIngredients: [],
//                oldIngredients: [ingredient.사과]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 22)!,
//                mealType: .간식2,
//                newIngredients: [],
//                oldIngredients: [ingredient.단호박]
//            )
//        ]
//    }
//}
//
//    // 돌림노래~~
//    static var mockMealsTwo: [MealPlan] {
//        let ingredient = Ingredient.Mock.self
//        return [
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 14)!,
//                endDate: Date.date(year: 2023, month: 11, day: 16)!,
//                mealType: .아침,
//                newIngredients: [ingredient.소고기],
//                oldIngredients: [ingredient.쌀]
//            ),
//            // 2nd
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 21)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .아침,
//                newIngredients: [ingredient.쌀],
//                oldIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 22)!,
//                endDate: Date.date(year: 2023, month: 11, day: 25)!,
//                mealType: .점심,
//                newIngredients: [],
//                oldIngredients: [ingredient.쌀, ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 22)!,
//                endDate: Date.date(year: 2023, month: 11, day: 24)!,
//                mealType: .저녁,
//                newIngredients: [],
//                oldIngredients: [ingredient.땅콩, ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
//            ),
//            .init(
//                startDate: Date.date(year: 2023, month: 11, day: 23)!,
//                endDate: Date.date(year: 2023, month: 11, day: 26)!,
//                mealType: .저녁,
//                newIngredients: [],
//                oldIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
//            )
//        ]
//    }
//}

extension Ingredient {
    static var mockNewIngredients: [Ingredient] = [
        Mock.당근
    ]
    static var mockOldIngredients: [Ingredient] = [
        Mock.쌀, Mock.소고기, Mock.청경채
    ]

    enum Mock {
        static var 쌀: Ingredient { .init(type: .곡물, name: "쌀") }
        static var 소고기: Ingredient { .init(type: .어육류, name: "소고기") }
        static var 사과: Ingredient { .init(type: .과일, name: "사과") }
        static var 브로콜리: Ingredient { .init(type: .채소, name: "브로콜리") }
        static var 아스파라거스: Ingredient { .init(type: .채소, name: "아스파라거스") }
        static var 단호박: Ingredient { .init(type: .채소, name: "단호박") }
        static var 땅콩: Ingredient { .init(type: .기타, name: "땅콩") }
        static var 당근: Ingredient { .init(type: .채소, name: "당근") }
        static var 청경채: Ingredient { .init(type: .채소, name: "청경채") }
    }
}

extension Ingredient {
    init(type: IngredientType, name: String) {
        self.id = UUID().hashValue
        self.name = name
        self.ableMonth = 6
        self.type = type
        self.description = name
        self.misMatches = []
        self.alternatives = []
    }
}
