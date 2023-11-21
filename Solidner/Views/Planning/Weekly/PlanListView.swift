//
//  PlanListView.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//
/**
 -[x] 오늘은 초록색이어야해
 -[x] 끼니 추가
 -[x] 리스트
 -[x] 헤더
 -[ ] 이유식/월령 바꾸기
 -[ ] 이유식 날짜 보이기
 -[x] 셀 1개
 -[x] 그룹
 -[ ] 이상 반응 보이게
 */
import SwiftUI

struct PlanListView: View {
    @State private var selectedDate = Date()
    let mealPlans: [MealPlan]
    let texts = TextLiterals.PlanList.self
    private(set) var mealsDict = [SolidDate:[MealPlan]]()
    let defaultCycleGap = 3

    init(mealPlans: [MealPlan] = MealPlan.mockMealsOne) {
        self.mealPlans = mealPlans
        mealsDict = Dictionary(grouping: mealPlans) { SolidDate(startDate: $0.startDate, endDate: $0.endDate) }
    }

    var body: some View {
        ScrollView {
            VStack {
                title
                dateScroll
                ThickDivider()
                mealGroupList
                ThickDivider()
                totalSetting
            }
        }
    }

    private var title: some View {
        HStack {
            Text(texts.yyyymmHeaderText(date: selectedDate))
                .font(.largeTitle).bold()
            Image(systemName: "chevron.down")
            Spacer()
        }
    }

    //TODO: - date 각 년월일 들어가게 :)
    private var dateScroll: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(1..<31) { number in
                    Button {
                        print(#function)
                    } label: {
//                        Text(texts.ddDateText(date: <#T##Date#>))
                        Text("\(number)일")
                            .foregroundStyle(Color.black).bold()
                            .padding(.horizontal, 25)
                            .padding(.vertical, 9)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray)
                            )
                    }
                }
            }
        }
    }

    // MARK: - meal Group List
    var mealGroupList: some View {
        VStack(spacing: 20) {
            ForEach(Array(mealsDict.keys.sorted(by: { $0.startDate < $1.startDate }).enumerated()), id: \.element) { index, solidDate in
                if let meals = mealsDict[solidDate] {
                    MealGroupView(
                        dateRange: solidDate.description,
                        mealPlans: meals,
                        isTodayInDateRange: Date().isInBetween(from: solidDate.startDate, to: solidDate.endDate)
                    )
                }
            }
            addNewMealPlan
        }
    }

    var addNewMealPlan: some View {
        let newStartDate = mealPlans.sorted { $0.endDate > $1.endDate }.first?.endDate.add(.day, value: 1) ?? (Date.date(year: selectedDate.year, month: selectedDate.month, day: 1) ?? Date())
        let newEndDate = newStartDate.add(.day, value: defaultCycleGap - 1)
        let dateRangeString = texts.dateRangeString(start: newStartDate, end: newEndDate)
        return MealGroupView(type: .addNew, dateRange: dateRangeString)
    }

    // MARK: - totalSetting
    var totalSetting: some View {
        Button {
            print(#function)
        } label: {
            HStack {
                Text(TextLiterals.SolidFoodBatchSetting.labelText)
                    .foregroundStyle(Color.black)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.gray)
            }

        }


    }

//    func mealView(meal: MealPlan.Meal) -> some View {
//        HStack {
//            meal.ingredients.enumerated().reduce(Text("")) { partialResult, enumeration  in
//                let (index, ingredient) = (enumeration.offset, enumeration.element)
//                let additionalText = index == meal.ingredients.endIndex ? Text("") : Text(", ")
//                return partialResult + Text(ingredient.description)
//                    .foregroundColor(ingredient.isNew ? .blue : .black) + additionalText
//            }
//            Spacer()
//        }
//        .padding()
//    }
}

// MARK: - Structure - Solid Date
extension PlanListView {
    struct SolidDate: Hashable {
        let startDate: Date
        let endDate: Date

        var description: String {
            TextLiterals.PlanList.dateRangeString(start: startDate, end: endDate)
        }
    }
}

//#Preview {
//    Group {
//        PlanListView(mealPlans: MealPlan.mockMealsOne)
////        PlanListView(mealPlans: MealPlan.mockMealsTwo)
//    }
//}
