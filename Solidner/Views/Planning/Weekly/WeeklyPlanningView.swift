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


extension Date {
    static func date(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return Calendar.current.date(from: dateComponents)
    }

    static func - (lhs: Date, rhs: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -rhs, to: lhs)!
    }

    static func componentsBetweenDates(from startDate: Date, to endDate: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)
    }

    static func range(from startDate: Date, to endDate: Date) -> [Date] {
        let diff = componentsBetweenDates(from: startDate, to: endDate).day!
        return (0...diff).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: startDate)
        }
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var weekDayKor: String {
        Weekday(rawValue: weekday)!.description
    }

    enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7

        var description: String {
            switch self {
            case .sunday:
                return "일"
            case .monday:
                return "월"
            case .tuesday:
                return "화"
            case .wednesday:
                return "수"
            case .thursday:
                return "목"
            case .friday:
                return "금"
            case .saturday:
                return "토"
            }
        }
    }
}

extension WeeklyPlanningView {
    // MARK: - Mock Meals

    var mockMealsZero: [MealPlan] { [] }
    var mockMealsOne: [MealPlan] {
        let meal14: [MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: true, name: "소고기"), .init(isNew: false, name: "쌀")],
                  time: .아침)
        ]
        let meal17: [MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: true, name: "밀가루"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "양배추"), .init(isNew: false, name: "단호박"), .init(isNew: false, name: "사과")],
                  time: .점심)
        ]
        let meal20: [MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "브로콜리"), .init(isNew: false, name: "사과")],
                  time: .점심),
            .init(ingredients:
                    [.init(isNew: true, name: "아스파라거스"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"),.init(isNew: false, name: "단호박"), ],
                  time: .저녁),
        ]
        let meal23: [MealPlan.Meal] = [
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
        let meal26: [MealPlan.Meal] = [
            .init(ingredients:
                    [.init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "사과"), .init(isNew: false, name: "브로컬리")],
                  time: .아침),
            .init(ingredients:
                    [.init(isNew: true, name: "아스파라거스"), .init(isNew: false, name: "쌀"), .init(isNew: false, name: "소고기"), .init(isNew: false, name: "단호박")],
                  time: .저녁)
        ]
        return [
            // MockData 용.. 강제 언래핑이니까 봐줘..
            MealPlan(startDate: .date(year: 2023, month: 10, day: 14)!, endDate: .date(year: 2023, month: 10, day: 16)!, meals: meal14, solidFoodDays: 13),
            MealPlan(startDate: .date(year: 2023, month: 10, day: 17)!, endDate: .date(year: 2023, month: 10, day: 17+2)!, meals: meal17, solidFoodDays: 16),
            MealPlan(startDate: .date(year: 2023, month: 10, day: 20)!, endDate: .date(year: 2023, month: 10, day: 20+2)!, meals: meal20, solidFoodDays: 19),
            MealPlan(startDate: .date(year: 2023, month: 10, day: 23)!, endDate: .date(year: 2023, month: 10, day: 23+2)!, meals: meal23, solidFoodDays: 22),
            MealPlan(startDate: .date(year: 2023, month: 10, day: 26)!, endDate: .date(year: 2023, month: 10, day: 26+2)!, meals: meal26, solidFoodDays: 25)
        ]
    }

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


//#Preview {
//    WeeklyPlanningView()
//}
