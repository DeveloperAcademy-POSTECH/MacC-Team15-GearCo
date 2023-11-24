//
//  MockPlanData.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct MealPlan: Identifiable, Hashable {
    private(set) var id = UUID()
    let startDate: Date
    let endDate: Date
    private(set) var mealType: MealType
    let testingIngredients: [Ingredient]
    let testedIngredients: [Ingredient]


    var dateString: String {
        "\(startDate.day)일(\(startDate.weekDayKor)) ~ \(endDate.day)일(\(endDate.weekDayKor))"
    }

    var ingredientsString: String {
        testedIngredients.map { $0.description }.joined(separator: ", ")
    }

    mutating func set(mealType: MealType) {
        self.mealType = mealType
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
            return "sun.max"
        case .점심:
            return "sun.horizon"
        case .저녁:
            return "moon"
        case .간식1:
            return "1.circle"
        case .간식2:
            return "2.circle"
        case .기타:
            return "plus"
        }
    }
}

extension MealType: Comparable {
    static func < (lhs: MealType, rhs: MealType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Ingredient: CustomStringConvertible, Identifiable, Hashable, Codable {
    private(set) var id = UUID()
    let type: IngredientType
    private(set) var ableMonth: Int = 6
    private(set) var misMatches: [Ingredient] = []
    private(set) var alternatives: [Ingredient] = []

    var description: String { name }
    var name: String

    func setMisMatches(ingredients: [Ingredient]) -> Self {
        var _self = self
        _self.misMatches = ingredients
        return _self
    }
}

enum IngredientType: Codable {
    case 곡물, 어육류, 노란채소, 녹색채소, 과일, 유제품, 기타채소, 기타

    var color: Color {
        switch self {
        case .곡물:
            return .grain
        case .어육류:
            return .greenVegitable
        case .노란채소:
            return .yellowVegitable
        case .녹색채소:
            return .greenVegitable
        case .과일:
            return .fruit
        case .유제품:
            return .dairy
        case .기타채소:
            return .etcVegitable
        case .기타:
            return .etcIngredient
        }
    }
}


extension MealPlan {
    static var mockMealsOne: [MealPlan] {
        let ingredient = Ingredient.Mock.self
        return [
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 14)!,
                endDate: Date.date(year: 2023, month: 11, day: 16)!,
                mealType: .아침,
                testingIngredients: [ingredient.소고기],
                testedIngredients: [ingredient.쌀]
            ),
            // 2nd
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 17)!,
                endDate: Date.date(year: 2023, month: 11, day: 20)!,
                mealType: .아침,
                testingIngredients: [ingredient.쌀],
                testedIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 17)!,
                endDate: Date.date(year: 2023, month: 11, day: 20)!,
                mealType: .점심,
                testingIngredients: [],
                testedIngredients: [ingredient.쌀, ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 17)!,
                endDate: Date.date(year: 2023, month: 11, day: 20)!,
                mealType: .저녁,
                testingIngredients: [ingredient.땅콩],
                testedIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
            ),
            // 3rd 21~24
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .아침,
                testingIngredients: [ingredient.쌀],
                testedIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .점심,
                testingIngredients: [ingredient.쌀],
                testedIngredients: [ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .저녁,
                testingIngredients: [],
                testedIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .간식1,
                testingIngredients: [],
                testedIngredients: [ingredient.단호박]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .간식2,
                testingIngredients: [],
                testedIngredients: [ingredient.사과]
            )
        ]
    }

    // 돌림노래~~
    static var mockMealsTwo: [MealPlan] {
        let ingredient = Ingredient.Mock.self
        return [
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 14)!,
                endDate: Date.date(year: 2023, month: 11, day: 16)!,
                mealType: .아침,
                testingIngredients: [ingredient.소고기],
                testedIngredients: [ingredient.쌀]
            ),
            // 2nd
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 21)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .아침,
                testingIngredients: [ingredient.쌀],
                testedIngredients: [ingredient.소고기, ingredient.사과, ingredient.브로콜리]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 22)!,
                endDate: Date.date(year: 2023, month: 11, day: 25)!,
                mealType: .점심,
                testingIngredients: [],
                testedIngredients: [ingredient.쌀, ingredient.소고기, ingredient.단호박, ingredient.아스파라거스]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 22)!,
                endDate: Date.date(year: 2023, month: 11, day: 24)!,
                mealType: .저녁,
                testingIngredients: [],
                testedIngredients: [ingredient.땅콩, ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
            ),
            .init(
                startDate: Date.date(year: 2023, month: 11, day: 23)!,
                endDate: Date.date(year: 2023, month: 11, day: 26)!,
                mealType: .저녁,
                testingIngredients: [],
                testedIngredients: [ingredient.쌀, ingredient.소고기, ingredient.사과, ingredient.단호박]
            )
        ]
    }
}

extension Ingredient {
    static var mockTestingIngredients: [Ingredient] = [
        Mock.당근
    ]
    static var mockTestedIngredients: [Ingredient] = [
        Mock.쌀, Mock.소고기, Mock.청경채
    ]

    enum Mock {
        static var 쌀: Ingredient { .init(type: .곡물, name: "쌀") }
        static var 소고기: Ingredient { .init(type: .어육류, name: "소고기") }
        static var 사과: Ingredient { .init(type: .과일, name: "사과") }
        static var 브로콜리: Ingredient { .init(type: .녹색채소, name: "브로콜리") }
        static var 아스파라거스: Ingredient { .init(type: .녹색채소, name: "아스파라거스") }
        static var 단호박: Ingredient { .init(type: .노란채소, name: "단호박") }
        static var 땅콩: Ingredient { .init(type: .기타, name: "땅콩") }
        static var 당근: Ingredient { .init(type: .기타채소, name: "당근") }
        static var 청경채: Ingredient { .init(type: .녹색채소, name: "청경채") }
    }
}
