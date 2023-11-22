//
//  MonthlyPlanningView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/13.
//

import SwiftUI

struct MonthlyPlanningView: View {
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private let lightGray = Color(#colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)) // #D9D9D9
    private let weekDayKorList = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let nowMonthWeekNums = Date.nowMonthWeeks()
    
    // Dummy struct
    struct planData {
        var startDate: Int
        var endDate: Int
    }
    let plans: [planData] =
    [planData(startDate: 1, endDate: 3),
     planData(startDate: 3, endDate: 5),
     planData(startDate: 2, endDate: 4),
     planData(startDate: 5, endDate: 7),
     planData(startDate: 8, endDate: 11),
     planData(startDate: 13, endDate: 14),
     planData(startDate: 21, endDate: 24),
     planData(startDate: 12, endDate: 15)]
    
    @State private var reducedPlans: [(first: planData, second: BarPosition)] = []
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 70)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    calendarCurrentYearMonth.padding(.bottom, 15)
                    VStack(spacing: 0) {
                        calendarWeekDayRow
                        ForEach(nowMonthWeekNums, id: \.self) { num in
                            calendarDayNumberRow(weekOfMonth: num)
                            calendarNewIngredientRow(weekOfMonth: num)
                        }
                        Spacer()
                    }.background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }.clipped().padding(.horizontal, 16)
            }
        }.background(Color(.lightGray))
            .onAppear {
                reducedPlans = reducePlanData(plans: plans)
                print(reducedPlans)
            }
    }
    
    private func calendarNewIngredientRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let newIngredientRowHeight = screenWidth * (64/390)
        let ingredientBarHeight = screenWidth * (22/390)
        let rowHorizontalPadding = screenWidth * (4/390)
        
        let gapToFirstBar = screenWidth * (10/390)
        let gapToSecondBar = screenWidth * (5/390)
        
        let barHorizontalPadding = screenWidth * (10/390)
        
        let plansInWeek: [(data: planData, position: BarPosition)]
        = reducePlanDataInWeek(weekOfMonth: weekOfMonth, reducedPlans: reducedPlans)
        
        let weekDates = Date.weekDates(weekOfMonth)
        let monthDates = Date.nowMonthDates()
        
        // 바 길이 계산
        func calculateBarWidth(plan: planData, isBarFromEnd: inout (left: Bool, right: Bool)) -> CGFloat {
            let cycleGap: CGFloat = CGFloat(plan.endDate - plan.startDate + 1)
            let dayNumsInWeek: [Int] = weekDates.map{ $0.day }
            var result: CGFloat = 0
            
            if dayNumsInWeek.contains(plan.startDate) &&
                dayNumsInWeek.contains(plan.endDate) {
                result = (mainDaySectionWidth * cycleGap) - (barHorizontalPadding * 2)
            } else if dayNumsInWeek.first! > plan.startDate {
                isBarFromEnd.left = true
                if dayNumsInWeek.first! == 1 {  // 1일 이전부터 이어지는 바
                    let weekDay = CGFloat(weekDates.first!.weekday)  // 요일
                    result = (mainDaySectionWidth * weekDay) - barHorizontalPadding + rowHorizontalPadding
                } else {
                    result = (mainDaySectionWidth * cycleGap) - barHorizontalPadding + rowHorizontalPadding
                }
            } else if dayNumsInWeek.last! < plan.endDate {
                isBarFromEnd.right = true
                if dayNumsInWeek.last! == monthDates.last!.day {    // 월말 이후까지 이어지는 바
                    let weekDay = weekDates.first!.weekday  // 요일
                    let dayGap = CGFloat(7 - weekDay + 1)
                    result = (mainDaySectionWidth * dayGap) - barHorizontalPadding + rowHorizontalPadding
                } else {
                    result = (mainDaySectionWidth * cycleGap) - barHorizontalPadding + rowHorizontalPadding
                }
            } else {
                fatalError("Error in MonthlyPlanningView: calculateBarWidth")
            }
            
            return result
        }
        
        // 재료 바 view return
        func ingredientBar(plan: planData) -> some View {
            var isBarFromEnd: (left: Bool, right: Bool) = (false, false)
            var barWidth: CGFloat = calculateBarWidth(plan: plan, isBarFromEnd: &isBarFromEnd)
            let barRadius: CGFloat = 4
                        
            return HStack {
                VStack {
                    HStack {
                        Text("고기고기고기")
                            .font(.system(size: 10))
                            .bold()
                            .foregroundColor(.white)
                            .padding(.leading, 7)
                        Spacer()
                    }
                }.frame(width: barWidth, height: ingredientBarHeight)
                .background {
                    Rectangle()
                        .foregroundColor(Color.pink.opacity(0.5))
                        .if(!isBarFromEnd.left) { view in
                            view.leftCornerRadius(barRadius)
                        }.if(!isBarFromEnd.right) { view in
                            view.rightCornerRadius(barRadius)
                        }
                }
            }
        }
        
//        func barLeftPadding(index: Int, isBarFromEnd: inout (left: Bool, right: Bool)) -> some View {
//            if index
//                return Spacer().frame()
//        }
        
        // MARK: 재료 바를 포함한 한 줄 return
        return VStack(spacing: 0) {
            Spacer().frame(height: gapToFirstBar)
            
            HStack(spacing: 0) {
                //                Spacer().frame(width: rowHorizontalPadding)
                ForEach(Array(plansInWeek.indices), id: \.self) { i in
                    
                    if plansInWeek[i].position == .first {
                        ingredientBar(plan: plansInWeek[i].data)
                    }
                }
                //                Spacer()
            }.frame(height: ingredientBarHeight)
            
            Spacer().frame(height: gapToSecondBar)
            
            HStack(spacing: 0) {
                Spacer().frame(width: rowHorizontalPadding)
                ForEach(Array(plansInWeek.indices), id: \.self) { i in
                    if plansInWeek[i].position == .second {
                        ingredientBar(plan: plansInWeek[i].data)
                    }
                }
                Spacer()
            }.frame(height: ingredientBarHeight)
            
            Spacer()
        }.frame(height: newIngredientRowHeight)
    }
    
    private func calendarDayNumberRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let dayNumberRowFrameHeight = screenWidth * (60/390)
        let dayNumberGap = screenWidth * (6/390)
        let rowHorizontalPadding = screenWidth * (4/390)
        let thisWeekDates: [Date] = Date.weekDates(weekOfMonth)
        
        func rowLeftEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.first! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: rowHorizontalPadding))
            }
        }
        func rowRightEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.last! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: rowHorizontalPadding))
            }
        }
        
        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                rowLeftEndSpacer()
                ForEach(thisWeekDates, id: \.self) { date in
                    VStack(spacing: 0) {
                        Text("\(date.day)")
                            .font(.system(size: 11))
                            .padding(.bottom, dayNumberGap)
                        Text("\(date.day)")
                            .font(.system(size: 17))
                    }.frame(width: mainDaySectionWidth)
                }
                rowRightEndSpacer()
            }.frame(height: dayNumberRowFrameHeight)
            calendarDivider
        }
    }
    
    private var calendarWeekDayRow: some View {
        // TODO: color 및 font 수정
        let mainHorizontalPadding = screenWidth * (4/390)
        let mainDaySectionWidth = screenWidth * (50/390)
        let weekDayRowFrameHeight = screenWidth * (25/390)
        
        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(weekDayKorList.indices, id: \.self) { i in
                    if i == 0 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                            .padding(.leading, mainHorizontalPadding)
                    } else if i == 6 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                            .padding(.trailing, mainHorizontalPadding)
                    } else {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                    }
                }
            }.frame(height: weekDayRowFrameHeight)
            calendarDivider
        }
    }
    
    private var calendarDivider: some View {
        Rectangle().frame(height: 1).foregroundColor(.black)
    }
    
    private var calendarCurrentYearMonth: some View {
        HStack {
            Text("2023년 10월").font(.title).bold()
            Spacer()
        }
    }
}

extension MonthlyPlanningView {
    enum BarPosition: Int {
        case first = 1
        case second = 2
    }
    
    private func reducePlanData(plans: [planData]) -> [(planData, BarPosition)] {
        let nowMonthDates = Date.nowMonthDates()
        let lastDateNum = nowMonthDates.last!.day
        var dict = Dictionary(uniqueKeysWithValues: (1...lastDateNum).map { ($0, 0) })
        
        var result: [(planData, BarPosition)] = []
        
        for plan in plans {
            var isPlanAccepted = true
            var isFirstBar = true
            
            for i in Range<Int>(plan.startDate...plan.endDate) {
                if dict[i] == 2 {
                    isPlanAccepted = false
                } else if dict[i] == 1 {
                    isFirstBar = false
                }
            }
            
            if isPlanAccepted {
                for i in Range<Int>(plan.startDate...plan.endDate) {
                    dict[i]! += 1
                }
                if isFirstBar {
                    result.append((plan, .first))
                } else {
                    result.append((plan, .second))
                }
            }
        }
        
        return result.sorted { $0.0.startDate < $1.0.startDate }    // startDate 순 정렬
    }
    
    private func reducePlanDataInWeek(weekOfMonth: Int,
                                      reducedPlans: [(first: planData, second: BarPosition)])
    -> [(planData, BarPosition)] {
        let dayNumsInWeek: [Int] = Date.weekDates(weekOfMonth).map{ $0.day }
        var result: [(planData, BarPosition)] = []
        
        for plan in reducedPlans {
            if dayNumsInWeek.contains(plan.first.startDate) ||
                dayNumsInWeek.contains(plan.first.endDate) {
                result.append(plan)
            }
        }
        return result.sorted { $0.0.startDate < $1.0.startDate }    // startDate 순 정렬
    }
}

struct MonthlyPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPlanningView()
    }
}
