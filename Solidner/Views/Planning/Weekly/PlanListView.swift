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
// TODO: - date 각 년월일 들어가게 :)
// TODO: - 문제있는 date만 표시될 수 있도록 새로운 struct를 선언해야 할까?
// TODO: - date 버튼 눌렀을 때 화면 전환 action
// TODO: - totalSetting으로 화면 전환

import SwiftUI

struct PlanListView: View {
    @EnvironmentObject private var user: UserOB
    @State private var selectedDate = Date()
    let mealPlans: [MealPlan]
    private let texts = TextLiterals.PlanList.self
    private(set) var mealsDict = [SolidDate:[MealPlan]]()

    init(mealPlans: [MealPlan] = MealPlan.mockMealsOne) {
        self.mealPlans = mealPlans
        mealsDict = Dictionary(grouping: mealPlans) { SolidDate(startDate: $0.startDate, endDate: $0.endDate) }
    }

    private enum K {
        static var rootVStackSpacing: CGFloat { 26 }
        static var defaultHorizontalPadding: CGFloat { 20 }

        static var titleHStackSpacing: CGFloat { 4 }
        static var titleTextColor: Color { .defaultText }
        static var chevronDownSFSymbolName: String { "chevron.down" }
        static var chevronDownColor: Color { .primeText }


        static var dateHStackSpacing: CGFloat { 12 }
        static var dateTextColor: Color { .secondaryText }
        static var dateButtonWidth: CGFloat { 70 }
        static var dateButtonHeight: CGFloat { 36 }
        static var dateButtonCornerRadius: CGFloat { 12 }
        static var dateButtonBackgroundColor: Color { .buttonBgColor }

        static var mealGroupListVStackSpacing: CGFloat { 40 }

        static var chevronRightSFSymbolName: String { "chevron.right" }
        static var chevronRightColor: Color { .primeText }

        static var solidTotalSettingTextColor: Color { .primeText }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: K.rootVStackSpacing) {
                title
                dateScroll
                ThickDivider()
                mealGroupList
                ThickDivider()
                totalSetting
            }
        }
    }
}

// MARK: - title
extension PlanListView {
    private var title: some View {
        Button {
            print(#function)
        } label: {
            HStack(spacing: K.titleHStackSpacing) {
                Text(texts.yyyymmHeaderText(date: selectedDate))
                    .headerFont2().bold()
                    .foregroundStyle(K.titleTextColor)
                Image(systemName: K.chevronDownSFSymbolName)
                    .foregroundStyle(K.chevronDownColor)
                    .bold()
                Spacer()
            }
        }
    }

    // TODO: - date 각 년월일 들어가게 :)
    // TODO: - 문제있는 date만 표시될 수 있도록 새로운 struct를 선언해야 할까?
    // TODO: - date 버튼 눌렀을 때 화면 전환 action
    private var dateScroll: some View {
        let endDateDay: Int = {
            let nextMonthFirstDay = Date.date(year: selectedDate.year, month: (selectedDate.month + 1) % 12 + 1, day: 1)!
            let currentMonthLastDay = nextMonthFirstDay.add(.day, value: -1)
            return currentMonthLastDay.day
        }()
        let spacer: some View = Spacer()
            .frame(width: K.defaultHorizontalPadding - K.dateHStackSpacing)

        return ScrollView(.horizontal) {
            HStack(spacing: K.dateHStackSpacing) {
                spacer
                ForEach(Array(1..<endDateDay), id: \.self) { number in
                    Button {
                        print(#function)
                    } label: {
                        dateScrollLabel(of: number)
                    }
                }
                spacer
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, -K.defaultHorizontalPadding)
    }

    private func dateScrollLabel(of number: Int) -> some View {
        Text(texts.ddDateText(date: number))
            .headerFont6()
            .foregroundStyle(Color.black)
            .frame(width: K.dateButtonWidth, height: K.dateButtonHeight)
            .background(
                RoundedRectangle(cornerRadius: K.dateButtonCornerRadius)
                    .fill(K.dateButtonBackgroundColor)
            )
    }
}

// MARK: - meal Group List

extension PlanListView {
    private var mealGroupList: some View {
        VStack(spacing: K.mealGroupListVStackSpacing) {
            let mealDictKeys = Array(mealsDict.keys.sorted(by: { $0.startDate < $1.startDate }).enumerated())

            ForEach(mealDictKeys, id: \.element) { index, solidDate in
                if let meals = mealsDict[solidDate] {
                    MealGroupView(
                        dateRange: solidDate.description,
                        displayDateInfo: DisplayDateInfoView(
                            from: solidDate.startDate,
                            to: solidDate.endDate),
                        mealPlans: meals,
                        isTodayInDateRange: Date().isInBetween(from: solidDate.startDate, to: solidDate.endDate)
                    )
                }
            }
            addNewMealPlan
        }
    }

    private var addNewMealPlan: some View {
        let newStartDate = mealPlans.sorted { $0.endDate > $1.endDate }.first?.endDate.add(.day, value: 1) ?? (Date.date(year: selectedDate.year, month: selectedDate.month, day: 1) ?? Date())
        let newEndDate = newStartDate.add(.day, value: user.planCycleGap.rawValue - 1)
        let dateRangeString = texts.dateRangeString(start: newStartDate, end: newEndDate)
        return MealGroupView(
            type: .addNew,
            dateRange: dateRangeString,
            displayDateInfo: DisplayDateInfoView(from: newStartDate, to: newEndDate)
        )
    }
}

// MARK: - totalSetting
// TODO: - totalSetting으로 화면 전환

extension PlanListView {
    private var totalSetting: some View {
        Button {
            print(#function)
        } label: {
            HStack {
                Text(texts.solidTotalSettingText)
                    .headerFont4()
                    .foregroundStyle(K.solidTotalSettingTextColor)
                Spacer()
                Image(systemName: K.chevronRightSFSymbolName)
                    .foregroundStyle(K.chevronRightColor)
                    .bold()
            }
        }
    }

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

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        PlanListView(mealPlans: MealPlan.mockMealsOne).environmentObject(UserOB())
    }
}
