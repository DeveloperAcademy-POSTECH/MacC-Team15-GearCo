//
//  WeeklyPlanningView.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//

import SwiftUI

struct WeeklyPlanningView: View {
    let mealPlans: [MealPlan]

    init(mealPlans: [MealPlan] = MealPlan.mockMealsZero) {
        self.mealPlans = mealPlans
    }

    var body: some View {
        VStack {
            title
            weeklyMeals
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

    var weeklyMeals: some View {
        ScrollView {
            ForEach(mealPlans) { mealPlan in
                MealPlanView(mealPlan: mealPlan)
                    .padding(10)
            }
        }
    }

    struct MealPlanView: View {
        var mealPlan: MealPlan

        var body: some View {
            HStack {
                dates
                meals
            }
        }

        var dates: some View {
            VStack {
                ForEach(Date.range(from: mealPlan.startDate, to: mealPlan.endDate), id: \.self) { date in
                    dateView(date: date)
                }
            }
            .frame(width: 30)
        }

        func dateView(date: Date) -> some View {
            VStack {
                Text(date.weekDayKor)
                    .font(.caption2)
                Text(date.day.description)
                    .font(.body).fontWeight(.semibold)
            }
        }

        var meals: some View {
            VStack(alignment: .leading) {
                if mealPlan.meals.count != 0 {
                    mealsView
                } else {
                    noMealsView
                }
                solidFoodDaysText
            }
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            }
            .frame(maxWidth: .infinity)
        }

        var mealsView: some View {
            let lastIndex = mealPlan.meals.indices.last
            return ForEach(Array(mealPlan.meals.enumerated()), id: \.element) { index, meal in
                mealView(meal: meal)
                if index != lastIndex {
                    Divider()
                }
            }
        }

        func mealView(meal: MealPlan.Meal) -> some View {
            HStack {
                Image(systemName: meal.time.icon)
                    .font(.body)

                meal.ingredients.enumerated().reduce(Text("")) { partialResult, enumeration  in
                    let (index, ingredient) = (enumeration.offset, enumeration.element)
                    let additionalText = index == meal.ingredients.endIndex ? Text("") : Text(", ")
                    return partialResult + Text(ingredient.description)
                        .foregroundColor(ingredient.isNew ? .blue : .black) + additionalText
                }
                Spacer()
            }.padding(10)
        }

        var noMealsView: some View {
            Text(TextLiterals.WeeklyPlanning.chooseIngredientToTestText)
                .padding(10)
        }

        var solidFoodDaysText: some View {
            HStack {
                Spacer()
                Text(mealPlan.solidFoodDaysString)
                    .font(.footnote)
                    .padding(10)
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

        var solidFoodDaysString: String {
            TextLiterals.WeeklyPlanning.solidFoodDayText(
                from: solidFoodDays,
                to: solidFoodDays + (Date.componentsBetweenDates(from: startDate, to: endDate).day!)
            )
        }

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

extension WeeklyPlanningView.MealPlan {
    static var mockMealsZero: [WeeklyPlanningView.MealPlan]  {
        let noMeal: [WeeklyPlanningView.MealPlan.Meal] = []
        return [
            // MockData 용.. 강제 언래핑이니까 봐줘..
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 14)!, endDate: .date(year: 2023, month: 10, day: 16)!, meals: noMeal, solidFoodDays: 13),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 17)!, endDate: .date(year: 2023, month: 10, day: 17+2)!, meals: noMeal, solidFoodDays: 16),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 20)!, endDate: .date(year: 2023, month: 10, day: 20+2)!, meals: noMeal, solidFoodDays: 19),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 23)!, endDate: .date(year: 2023, month: 10, day: 23+2)!, meals: noMeal, solidFoodDays: 22),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 26)!, endDate: .date(year: 2023, month: 10, day: 26+2)!, meals: noMeal, solidFoodDays: 25)
        ]
    }
    static var mockMealsOne: [WeeklyPlanningView.MealPlan] {
        let meal14: [WeeklyPlanningView.MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: true, name: "소고기"), .init(isNew: false, name: "쌀")],
                  time: .아침)
        ]
        let meal17: [WeeklyPlanningView.MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: true, name: "밀가루"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "양배추"), .init(isNew: false, name: "단호박"), .init(isNew: false, name: "사과")],
                  time: .점심)
        ]
        let meal20: [WeeklyPlanningView.MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "브로콜리"), .init(isNew: false, name: "사과")],
                  time: .점심),
            .init(ingredients:
                    [.init(isNew: true, name: "아스파라거스"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"),.init(isNew: false, name: "단호박"), ],
                  time: .저녁),
        ]
        let meal23: [WeeklyPlanningView.MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "사과"), .init(isNew: false, name: "브로콜리")],
                  time: .아침),
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "단호박"), .init(isNew: false, name: "아스파라거스")],
                  time: .점심),
            .init(ingredients:
                    [.init(isNew: true, name: "땅콩"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "사과"), .init(isNew: false, name: "단호박")],
                  time: .점심),
        ]
        let meal26: [WeeklyPlanningView.MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "사과"), .init(isNew: false, name: "브로컬리")],
                  time: .아침),
            .init(ingredients:
                    [.init(isNew: true, name: "아스파라거스"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "단호박")],
                  time: .저녁)
        ]
        return [
            // MockData 용.. 강제 언래핑이니까 봐줘..
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 14)!, endDate: .date(year: 2023, month: 10, day: 16)!, meals: meal14, solidFoodDays: 13),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 17)!, endDate: .date(year: 2023, month: 10, day: 17+2)!, meals: meal17, solidFoodDays: 16),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 20)!, endDate: .date(year: 2023, month: 10, day: 20+2)!, meals: meal20, solidFoodDays: 19),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 23)!, endDate: .date(year: 2023, month: 10, day: 23+2)!, meals: meal23, solidFoodDays: 22),
            WeeklyPlanningView.MealPlan(startDate: .date(year: 2023, month: 10, day: 26)!, endDate: .date(year: 2023, month: 10, day: 26+2)!, meals: meal26, solidFoodDays: 25)
        ]
    }
}

//#Preview {
//    WeeklyPlanningView()
//}
