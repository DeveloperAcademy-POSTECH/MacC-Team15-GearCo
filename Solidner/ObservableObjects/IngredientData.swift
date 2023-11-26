//
//  IngredientData.swift
//  Solidner
//
//  Created by 이재원 on 11/26/23.
//

import Foundation

class IngredientData: ObservableObject {
    static let shared = IngredientData()
    
    @Published var ingredients: [Ingredient] = []

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
            
            let ingredientData = try decoder.decode(IngredientsContainer.self, from: data)
            let ingredients = ingredientData.Ingredients
            print(ingredients)
//            self.ingredients = ingredientData
        } catch {
            print("Error decoding JSON data: \(error)")
        }
    }
}
