//
//  WeeklyPlanningView.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//

import SwiftUI

struct WeeklyPlanningView: View {
    var body: some View {
        VStack {
            title
        }
    }

    var title: some View {
        HStack {
            Text(TextLiterals.WeeklyPlanning.weeklyPlanningText)
                .font(.largeTitle).bold()
            Spacer()
            Button("편집") {
                print("편집 버튼 눌림")
            }
        }
    }


}

extension WeeklyPlanningView {
    // MARK: - Mock Meals

    struct MealPlan: Identifiable {
        var id: UUID = UUID()
        var startDate: Date
        var endDate: Date
        var meals: [Meal]
        var solidFoodDays: Int

        struct Meal: Identifiable, Hashable {
            var id: UUID = UUID()

            var ingredients: [Ingredient]
            var time: MealTime

            var ingredientsString: String {
                ingredients.map { $0.description }.joined(separator: ", ")
            }

        }

        enum MealTime {
            case 아침, 점심, 저녁, 간식1, 간식2

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
                }
            }
        }

        struct Ingredient: CustomStringConvertible, Hashable {
            var description: String { name }

            var isNew: Bool
            var name: String
        }
    }
}


//#Preview {
//    WeeklyPlanningView()
//}
