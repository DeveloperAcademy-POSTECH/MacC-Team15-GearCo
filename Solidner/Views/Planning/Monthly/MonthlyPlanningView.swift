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
    // MARK: 이전 달의 데이터와 이후 달의 데이터는 -2, 33 등과 같이 표현할 것.
    let plans: [planData] =
    [
     planData(startDate: -1, endDate: 1),
     planData(startDate: 2, endDate: 4),
     planData(startDate: 2, endDate: 3),
     planData(startDate: 5, endDate: 7),
     planData(startDate: 8, endDate: 10),
     planData(startDate: 9, endDate: 11),
     planData(startDate: 13, endDate: 14),
     planData(startDate: 11, endDate: 12),
     planData(startDate: 16, endDate: 19),
     planData(startDate: 16, endDate: 18),
     planData(startDate: 19, endDate: 22),
     planData(startDate: 19, endDate: 22),
     planData(startDate: 21, endDate: 24),
     planData(startDate: 21, endDate: 24),
     planData(startDate: 23, endDate: 26),
     planData(startDate: 24, endDate: 25),
     planData(startDate: 26, endDate: 27),
     planData(startDate: 29, endDate: 30),
     planData(startDate: 29, endDate: 31),
     planData(startDate: 27, endDate: 32)
    ]
    
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
//                for plan in reducedPlans {
//                    print("plan :: \(plan.first.startDate)~\(plan.first.endDate) / \(plan.second)")
//                }
            }
    }
    
    // MARK: 재료 바 Row return 함수
    private func calendarNewIngredientRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let newIngredientRowHeight = screenWidth * (64/390)
        let ingredientBarHeight = screenWidth * (22/390)
        let rowHorizontalPadding = screenWidth * (4/390)
        
        let gapToFirstBar = screenWidth * (10/390)
        let gapToSecondBar = screenWidth * (5/390)
        
        let barHorizontalPadding = screenWidth * (10/390)
        let endPadding = barHorizontalPadding + rowHorizontalPadding
        
        let plansInWeek: [(data: planData, position: BarPosition)]
        = reducePlanDataInWeek(weekOfMonth: weekOfMonth, reducedPlans: reducedPlans)
        
        var plansInWeekFirstLine: [planData] {
            plansInWeek.filter { $0.position == .first }.map { $0.data }
        }
        var plansInWeekSecondLine: [planData] {
            plansInWeek.filter { $0.position == .second }.map { $0.data }
        }
        
        let weekDates = Date.weekDates(weekOfMonth)
        let dayNumsInWeek: [Int] = weekDates.map{ $0.day }
        let monthDates = Date.nowMonthDates()
        
        
        // MARK: 바 길이 계산
        func calculateBarWidth(plan: planData, isBarFromEnd: (left: Bool, right: Bool)) -> CGFloat {
            var cycle: CGFloat {
                if isBarFromEnd.left {
                    return CGFloat(plan.endDate - weekDates.first!.day + 1)
                } else if isBarFromEnd.right {
                    return CGFloat(weekDates.last!.day - plan.startDate + 1)
                } else {
                    return CGFloat(plan.endDate - plan.startDate + 1)
                }
            }
            var result: CGFloat = 0
            
            if dayNumsInWeek.contains(plan.startDate) &&
                dayNumsInWeek.contains(plan.endDate) {
                result = (mainDaySectionWidth * cycle) - (barHorizontalPadding * 2)
            } else if isBarFromEnd.left {
                if dayNumsInWeek.first! == 1 {  // 1일 이전부터 이어지는 바
                    // 빈 날의 공간 + plan의 마지막 날까지
                    let weekDay = CGFloat(weekDates.first!.weekday + plan.endDate - 1)
                    result = (mainDaySectionWidth * weekDay) - barHorizontalPadding * 2 + endPadding
                } else {
                    result = (mainDaySectionWidth * cycle) - barHorizontalPadding * 2 + endPadding
                }
            } else if isBarFromEnd.right {
                if dayNumsInWeek.last! == monthDates.last!.day {    // 월말 이후까지 이어지는 바
                    let weekDay = monthDates[plan.startDate-1].weekday // 요일
                    let dayGap = CGFloat(7 - weekDay + 1)
                    result = (mainDaySectionWidth * dayGap) - barHorizontalPadding + rowHorizontalPadding
                } else {
                    result = (mainDaySectionWidth * cycle) - barHorizontalPadding + rowHorizontalPadding
                }
            } else {
                // TODO: Error fix
                fatalError("Error in MonthlyPlanningView: calculateBarWidth")
            }
            
            return result
        }
        
        // MARK: 재료 바 한 개 return 함수
        func ingredientBar(plan: planData, index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
            let barWidth: CGFloat = calculateBarWidth(plan: plan, isBarFromEnd: isBarFromEnd)
            let barRadius: CGFloat = 4
                        
            return VStack(spacing: 0) {
                HStack(spacing: 0) {
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
        
        // MARK: 바 한 개 왼쪽, 오른쪽 공간 계산
        func barLeftPadding(plans: [planData], index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
            
            switch plans.count {
            case 0:
                return AnyView(Spacer())
            case 1: // 한 줄에 plan이 하나일 때
                if isBarFromEnd.left {  // 왼쪽으로 붙여야 하면
                    return AnyView(EmptyView())
                } else if isBarFromEnd.right {  // 오른쪽으로 붙여야 하면
                    return AnyView(Spacer())
                } else {    // 어느 쪽으로도 붙이지 않을 때
                    var dayGap: CGFloat
                    // 시작일과(plan 1개이므로 index=0) 그 주의 첫 번째 날의 차이를 빼어 빈 날짜가 며칠인지 계산
                    if dayNumsInWeek.first! == 1 {
                        // 주의 시작일이 1일일 때
                        dayGap = CGFloat(plans[0].startDate - 1 + weekDates.first!.weekday - 1)
                    } else {
                        dayGap = CGFloat(plans[0].startDate - dayNumsInWeek.first!)
                    }
                    let width = mainDaySectionWidth * dayGap + endPadding
                    return AnyView(Spacer().frame(width: width))
                }
            default:    // 한 줄에 plan이 2개 이상일 때
                if isBarFromEnd.left {  // 왼쪽으로 붙여야 하면
                    return AnyView(EmptyView())
                } else if isBarFromEnd.right {  // 오른쪽으로 붙여야 하면
                    // 2개 이상일 때 오른쪽으로 붙여야 한다는 것은 index = 1이상
                    let prevEndDate = plans[index-1].endDate
                    let dayGap = CGFloat(plans[index].startDate - prevEndDate - 1)
                    let width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                    return AnyView(Spacer().frame(width: width))
                } else {    // 어느 쪽으로도 붙이지 않을 때
                    var width: CGFloat
                    if dayNumsInWeek.first! == 1 {  // 주의 시작일이 1일일 때
                        if index == 0 { // 첫 블록이라면
                            let dayGap = CGFloat(plans[0].startDate - 1 + weekDates.first!.weekday - 1)
                            width = mainDaySectionWidth * dayGap + endPadding
                        } else {    // 첫 블록이 아니라면 (왼쪽 패딩이므로, 마지막 블록인 지는 관심 없음.)
                            let prevEndDate = plans[index-1].endDate
                            let dayGap = CGFloat(plans[index].startDate - prevEndDate - 1)
                            width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                        }
                    } else {    // 첫 주가 아닐 때
                        if index == 0 { // 첫 블록이라면
                            let dayGap = CGFloat(plans[0].startDate - dayNumsInWeek.first!)
                            width = mainDaySectionWidth * dayGap + endPadding
                        } else {    // 첫 블록이 아니라면 (왼쪽 패딩이므로, 마지막 블록인 지는 관심 없음.)
                            let prevEndDate = plans[index-1].endDate
                            let dayGap = CGFloat(plans[index].startDate - prevEndDate - 1)
                            width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                        }
                    }
                    return AnyView(Spacer().frame(width: width))
                }
            }
        }
        func barRightPadding(plans: [planData], index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
            switch plans.count {
            case 0:
                return AnyView(EmptyView())
            case 1: // 한 줄에 plan이 하나일 때
                if isBarFromEnd.left {  // 왼쪽으로 붙여야 하면
                    return AnyView(Spacer())
                } else if isBarFromEnd.right {  // 오른쪽으로 붙여야 하면
                    return AnyView(EmptyView())
                } else {    // 어느 쪽으로도 붙이지 않을 때
                    // 한 줄에 plan이 하나일 때, 어느 쪽으로도 붙이지 않는다면, left Padding에서 계산했으므로, right Padding은 Spacer()로 밀어버린다.
                    return AnyView(Spacer())
                }
            default:    // 한 줄에 plan이 2개 이상일 때
                if isBarFromEnd.left {  // 왼쪽으로 붙여야 하면
                    // right padding은 이미 다음 블록의 left padding에서 계산함.
                    return AnyView(EmptyView())
                } else if isBarFromEnd.right {  // 오른쪽으로 붙여야 하면
                    return AnyView(EmptyView())
                } else {    // 어느 쪽으로도 붙이지 않을 때
                    if index == plans.count - 1 {   // 마지막 블록이라면
                        return AnyView(Spacer())
                    } else {
                        return AnyView(EmptyView())
                    }
                }
            }
        }
        
        // MARK: 바가 왼쪽에서 이어지는 지, 오른쪽에서 이어지는 지 계산
        func calculateIsBarFromEnd(plan: planData) -> (Bool, Bool) {
            var result: (left: Bool, right: Bool) = (false, false)
            if dayNumsInWeek.first! > plan.startDate {
                result.left = true
            } else if dayNumsInWeek.last! < plan.endDate {
                result.right = true
            }
            
            return result
        }
        
        // MARK: 재료 바를 포함한 한 줄 return
        return VStack(spacing: 0) {
            Spacer().frame(height: gapToFirstBar)
            
            HStack(spacing: 0) {
                ForEach(Array(plansInWeekFirstLine.indices), id: \.self) { i in
                    let isBarFromEnd: (Bool, Bool) = calculateIsBarFromEnd(plan: plansInWeekFirstLine[i])
                    barLeftPadding(plans: plansInWeekFirstLine, index: i, isBarFromEnd: isBarFromEnd)
                    ingredientBar(plan: plansInWeekFirstLine[i], index: i, isBarFromEnd: isBarFromEnd)
                    barRightPadding(plans: plansInWeekFirstLine, index: i, isBarFromEnd: isBarFromEnd)
                }
            }.frame(height: ingredientBarHeight)
            
            Spacer().frame(height: gapToSecondBar)
            
            HStack(spacing: 0) {
                ForEach(Array(plansInWeekSecondLine.indices), id: \.self) { i in
                    let isBarFromEnd: (Bool, Bool) = calculateIsBarFromEnd(plan: plansInWeekSecondLine[i])
                    barLeftPadding(plans: plansInWeekSecondLine, index: i, isBarFromEnd: isBarFromEnd)
                    ingredientBar(plan: plansInWeekSecondLine[i], index: i, isBarFromEnd: isBarFromEnd)
                    barRightPadding(plans: plansInWeekSecondLine, index: i, isBarFromEnd: isBarFromEnd)
                }
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
        // key는 -7 ~ 마지막일+7 까지의 Int형 정수, value는 (first: Bool, second: Bool)인 tuple로 이루어진 dictionary
        // ex: { 1: (true, false), 2: (true, false)... }  (true가 가용한(비어있는) 상태)
        var dict = Dictionary(uniqueKeysWithValues: (-7...lastDateNum+7).map { ($0, (first: true, second: true)) })
        
        var result: [(planData, BarPosition)] = []
        
        // 시작일 순 정렬
        let sortedPlans = plans.sorted{ $0.startDate < $1.startDate }
        
        for plan in sortedPlans {
            var isPlanAcceptedOnFirstLine = true
            var isPlanAcceptedOnSecondLine = true
            
            for i in Range<Int>(plan.startDate...plan.endDate) {
                // plan의 모든 날짜를 순회하며 첫줄이나 둘째줄에 들어갈 수 있는 지 검사.
                if !dict[i]!.first {
                    isPlanAcceptedOnFirstLine = false
                }
                if !dict[i]!.second {
                    isPlanAcceptedOnSecondLine = false
                }
            }
            
            if isPlanAcceptedOnFirstLine {
                // 첫 줄에 수용 가능하면, dictionary 상태를 false (수용불가능)으로 바꾸고, append
                for i in Range<Int>(plan.startDate...plan.endDate) {
                    dict[i]!.first = false
                }
                result.append((plan, .first))
            } else if isPlanAcceptedOnSecondLine {
                // 첫 줄에 가능한 지 우선 체크 후 둘째 줄을 체크
                for i in Range<Int>(plan.startDate...plan.endDate) {
                    dict[i]!.second = false
                }
                result.append((plan, .second))
            }
//            print(plan.startDate, plan.endDate)
//            for i in Range<Int>(-1...4) {
//                print("\(i)일차 - ", dict[i]!)
//            }
        }
        
        return result.sorted { $0.0.startDate < $1.0.startDate }    // startDate 순 정렬
    }
    
    private func reducePlanDataInWeek(weekOfMonth: Int,
                                      reducedPlans: [(first: planData, second: BarPosition)])
    -> [(planData, BarPosition)] {
        let dayNumsInWeek: [Int] = Date.weekDates(weekOfMonth).map{ $0.day }
        var result: [(planData, BarPosition)] = []
        
        for plan in reducedPlans.sorted(by: { $0.0.startDate < $1.0.startDate }) {
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
