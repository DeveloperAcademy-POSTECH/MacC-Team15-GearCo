//
//  IngredientData.swift
//  Solidner
//
//  Created by 이재원 on 11/26/23.
//

import SwiftUI

struct Ingredient: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let type: IngredientType
    let ableMonth: Int
    let description: String
    
    var misMatches: [Ingredient] = []
    var alternatives: [Ingredient] = []

    func setMisMatches(ingredients: [Ingredient]) -> Self {
        // TODO: 로직 변경
        var _self = self
        _self.misMatches = ingredients
        return _self
    }
}

enum IngredientType: Int, Codable, CaseIterable {
    case 채소 = 1
    case 과일 = 2
    case 곡물 = 3
    case 어육류 = 4
    case 유제품 = 5
    case 기타 = 6
    
    var description: String {
        switch self {
        case .채소:
            return "채소"
        case .과일:
            return "과일"
        case .곡물:
            return "곡물"
        case .어육류:
            return "어육류"
        case .유제품:
            return "유제품"
        case .기타:
            return "기타"
        }
    }

    var color: Color {
        switch self {
        case .채소:
            return .greenVegitable
        case .과일:
            return .fruit
        case .곡물:
            return .grain
        case .어육류:
            return .fishAndMeat
        case .유제품:
            return .dairy
        case .기타:
            return .etcIngredient
        }
    }
}
