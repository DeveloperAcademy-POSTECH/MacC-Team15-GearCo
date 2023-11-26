//
//  IngredientData.swift
//  Solidner
//
//  Created by 이재원 on 11/26/23.
//

import Foundation
import SwiftUI

class IngredientData: ObservableObject {
    static let shared = IngredientData()
    
    // key = id / value = Ingredient Object
    @Published var ingredients: [Int: Ingredient] = [:]

    private init() {
        loadIngredientsDataFromJSON()
    }
    
    private struct DecodeIngredient: Decodable, Identifiable {
        let id: Int
        let name: String
        let type: Int
        let ableMonth: Int
        let misMatches: [Int]
        let alternatives: [Int]
        let others: String
    }
    private struct IngredientsContainer: Decodable {
        let Ingredients: [DecodeIngredient]
    }
    
    private func loadIngredientsDataFromJSON() {
        guard let url = Bundle.main.url(forResource: "IngredientData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load IngredientData.json from bundle.")
            return
        }

        do {
            let decoder = JSONDecoder()
            
            let JSONData = try decoder.decode(IngredientsContainer.self, from: data)
            let JSONDataIngredients = JSONData.Ingredients
            
            // 재료 객체 생성 및 append
            for ingredient in JSONDataIngredients {
                let id = ingredient.id
                let name = ingredient.name
                let type = IngredientType(rawValue: ingredient.type) ?? .기타
                let ableMonth = ingredient.ableMonth
                let description = ingredient.others
                
                let ingredientObject = Ingredient(id: id, name: name, type: type, ableMonth: ableMonth, description: description)
                self.ingredients[id] = ingredientObject
            }
            
            // misMatch, alternatives 초기화
            for ingredient in JSONDataIngredients {
                let id = ingredient.id
                let misMatches = ingredient.misMatches
                let alternatives = ingredient.alternatives
                
                for i in misMatches {
                    self.ingredients[id]?.misMatches.append(self.ingredients[i]!)
                    self.ingredients[id]?.alternatives.append(self.ingredients[i]!)
                }
            }
        } catch {
            print("Error decoding JSON data: \(error)")
        }
    }
}
