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
        
    // 이전 달의 데이터와 이후 달의 데이터는 -2, 33 등과 같이 표현됨.
    struct PlanData {
        var mealPlan: MealPlan
        var startDay: Int
        var endDay: Int
    }
    
    @EnvironmentObject var user: UserOB
    @EnvironmentObject var mealPlansOB: MealPlansOB
    let ingredientData = IngredientData.shared
    
    @Binding var showWeekly: Bool
    @Binding var selectedMonthDate: Date
    
    @State private var reducedPlans: [(first: PlanData, second: BarPosition)] = []
    @State private var nowMonthWeekNums = Date.nowMonthWeeks()
    
    @State private var showChangeMonthModal = false
    @State private var showTotalSetting = false
    @State private var isMyPageOpenning = false
    
    var body: some View {
        VStack(spacing: 0) {
//            #warning("테스트 데이터 생성용 버튼")
//            Button {
//                let sDate = user.solidStartDate.add(.day, value: Int.random(in: 0...90))
//                let meal: MealOB = MealOB(startDate: sDate, cycleGap: CycleGaps(rawValue: Int.random(in: 1...4))!,
//                                          mealPlansOB: mealPlansOB
//                )
//                meal.set(mealType: MealType(rawValue: Int.random(in: 0...5))!)
//                for _ in Range<Int>(0...Int.random(in: 0...2)) {
//                    meal.addIngredient(ingredient: ingredientData.ingredients.randomElement()!.value, in: .new)
//                }
//                for _ in Range<Int>(0...Int.random(in: 0...5)) {
//                    meal.addIngredient(ingredient: ingredientData.ingredients.randomElement()!.value, in: .old)
//                }
//                FirebaseManager.shared.saveMealPlan(meal, user: user)
//            } label: {
//                HStack {
//                    Image(systemName: "lasso.and.sparkles")
//                        .foregroundStyle(Color.pink)
//                        .frame(width: 40)
//                    Text("랜덤 이유식 계획 생성 - 테스트용")
//                        .bodyFont2()
//                        .foregroundColor(Color.pink)
//                }
//            }

            monthlyHeader
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    calendarCurrentYearMonth.padding(.bottom, 26)
                    VStack(spacing: 0) {
                        calendarWeekDayRow
                        ForEach(nowMonthWeekNums, id: \.self) { num in
                            calendarDayNumberRow(weekOfMonth: num)
                            calendarNewIngredientRow(weekOfMonth: num)
                        }
                        Spacer()
                    }.background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.defaultText_wh)
                    }
                    Spacer().frame(height: 100.responsibleHeight)
                    ThickDivider()
                        .padding(.horizontal, -16)
                    // TODO: Magic Number 수정
                    totalSetting
                        .padding(top: 26.responsibleHeight, leading: 0, bottom: 75.responsibleHeight, trailing: 0)
                }.padding(.horizontal, 16).clipped()
                    .defaultViewBodyTopPadding()
            }
        }.background(Color.secondBgColor)
            .task {
                if mealPlansOB.isLoaded {
                    var plans: [PlanData] = []
                    mealPlansOB.currentFilter = .month(date: selectedMonthDate)
                    for plan in mealPlansOB.filteredMealPlans {
                        let newPlan = PlanData(mealPlan: plan, startDay: plan.startDate.day, endDay: plan.endDate.day)
                        plans.append(newPlan)
                    }
                    adjustPlanDataDays(plans: &plans)
                    reducedPlans = reducePlanData(plans: plans)
                }
            }.onChange(of: mealPlansOB.filteredMealPlans) { value in
                var plans: [PlanData] = []
                for plan in mealPlansOB.filteredMealPlans {
                    let newPlan = PlanData(mealPlan: plan, startDay: plan.startDate.day, endDay: plan.endDate.day)
                    plans.append(newPlan)
                }
                adjustPlanDataDays(plans: &plans)
                reducedPlans = reducePlanData(plans: plans)
            }.onChange(of: selectedMonthDate) { newValue in
                mealPlansOB.currentFilter = .month(date: newValue)
                nowMonthWeekNums = selectedMonthDate.monthWeeks()
            }.sheet(isPresented: $showChangeMonthModal) {
                ChangeMonthHalfModal(selectedDate: $selectedMonthDate, fromDate: user.solidStartDate)
            }
    }
    
    private var totalSetting: some View {
        Button {
            showTotalSetting = true
        } label: {
            HStack {
                Text("이유식 전체 설정")
                    .customFont(.header4, color: .primeText)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.primeText)
                    .bold()
            }
        }
        .navigationDestination(isPresented: $showTotalSetting) {
            PlanBatchSettingView()
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
        
        let plansInWeek: [(data: PlanData, position: BarPosition)]
        = reducePlanDataInWeek(weekOfMonth: weekOfMonth, reducedPlans: reducedPlans)
        
        var plansInWeekFirstLine: [PlanData] {
            plansInWeek.filter { $0.position == .first }.map { $0.data }
        }
        var plansInWeekSecondLine: [PlanData] {
            plansInWeek.filter { $0.position == .second }.map { $0.data }
        }
        
        let weekDates = selectedMonthDate.weekDates(weekOfMonth)
        let dayNumsInWeek: [Int] = weekDates.map{ $0.day }
        let monthDates = selectedMonthDate.monthDates()
        
        
        // MARK: 바 길이 계산
        func calculateBarWidth(plan: PlanData, isBarFromEnd: (left: Bool, right: Bool)) -> CGFloat {
            var cycle: CGFloat {
                if isBarFromEnd.left {
                    return CGFloat(plan.endDay - weekDates.first!.day + 1)
                } else if isBarFromEnd.right {
                    return CGFloat(weekDates.last!.day - plan.startDay + 1)
                } else {
                    return CGFloat(plan.endDay - plan.startDay + 1)
                }
            }
            var result: CGFloat = 0
            
            if dayNumsInWeek.contains(plan.startDay) &&
                dayNumsInWeek.contains(plan.endDay) {
                result = (mainDaySectionWidth * cycle) - (barHorizontalPadding * 2)
            } else if isBarFromEnd.left {
                if dayNumsInWeek.first! == 1 {  // 1일 이전부터 이어지는 바
                    // 빈 날의 공간 + plan의 마지막 날까지
                    let weekDay = CGFloat(weekDates.first!.weekday + plan.endDay - 1)
                    result = (mainDaySectionWidth * weekDay) - barHorizontalPadding * 2 + endPadding
                } else {
                    result = (mainDaySectionWidth * cycle) - barHorizontalPadding * 2 + endPadding
                }
            } else if isBarFromEnd.right {
                if dayNumsInWeek.last! == monthDates.last!.day {    // 월말 이후까지 이어지는 바
                    let weekDay = monthDates[plan.startDay-1].weekday // 요일
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
        func ingredientBar(plan: PlanData, index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
            let barWidth: CGFloat = calculateBarWidth(plan: plan, isBarFromEnd: isBarFromEnd)
            let barRadius: CGFloat = 4
            
            var newIngredientText: String {
                var res = ""
                let newIngredients = plan.mealPlan.newIngredients
                for (index, ingredient) in newIngredients.enumerated() {
                    if index == 0 {
                        res += ingredient.name
                    } else if index == 1 {
                        res += ", \(ingredient.name)"
                    }
                }
                return res
            }
                        
            return VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(newIngredientText)
                        .weekDisplayFont3()
                        .foregroundColor(.defaultText_wh)
                        .padding(.leading, 7)
                    Spacer()
                }
            }.frame(width: barWidth, height: ingredientBarHeight)
            .background {
                Rectangle()
                    .foregroundColor(.accentColor1)
                    .if(!isBarFromEnd.left) { view in
                        view.leftCornerRadius(barRadius)
                    }.if(!isBarFromEnd.right) { view in
                        view.rightCornerRadius(barRadius)
                    }
            }
        }
        
        // MARK: 바 한 개 왼쪽, 오른쪽 공간 계산
        func barLeftPadding(plans: [PlanData], index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
            
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
                        dayGap = CGFloat(plans[0].startDay - 1 + weekDates.first!.weekday - 1)
                    } else {
                        dayGap = CGFloat(plans[0].startDay - dayNumsInWeek.first!)
                    }
                    let width = mainDaySectionWidth * dayGap + endPadding
                    return AnyView(Spacer().frame(width: width))
                }
            default:    // 한 줄에 plan이 2개 이상일 때
                if isBarFromEnd.left {  // 왼쪽으로 붙여야 하면
                    return AnyView(EmptyView())
                } else if isBarFromEnd.right {  // 오른쪽으로 붙여야 하면
                    // 2개 이상일 때 오른쪽으로 붙여야 한다는 것은 index = 1이상
                    let prevEndDate = plans[index-1].endDay
                    let dayGap = CGFloat(plans[index].startDay - prevEndDate - 1)
                    let width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                    return AnyView(Spacer().frame(width: width))
                } else {    // 어느 쪽으로도 붙이지 않을 때
                    var width: CGFloat
                    if dayNumsInWeek.first! == 1 {  // 주의 시작일이 1일일 때
                        if index == 0 { // 첫 블록이라면
                            let dayGap = CGFloat(plans[0].startDay - 1 + weekDates.first!.weekday - 1)
                            width = mainDaySectionWidth * dayGap + endPadding
                        } else {    // 첫 블록이 아니라면 (왼쪽 패딩이므로, 마지막 블록인 지는 관심 없음.)
                            let prevEndDate = plans[index-1].endDay
                            let dayGap = CGFloat(plans[index].startDay - prevEndDate - 1)
                            width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                        }
                    } else {    // 첫 주가 아닐 때
                        if index == 0 { // 첫 블록이라면
                            let dayGap = CGFloat(plans[0].startDay - dayNumsInWeek.first!)
                            width = mainDaySectionWidth * dayGap + endPadding
                        } else {    // 첫 블록이 아니라면 (왼쪽 패딩이므로, 마지막 블록인 지는 관심 없음.)
                            let prevEndDate = plans[index-1].endDay
                            let dayGap = CGFloat(plans[index].startDay - prevEndDate - 1)
                            width = mainDaySectionWidth * dayGap + barHorizontalPadding * 2
                        }
                    }
                    return AnyView(Spacer().frame(width: width))
                }
            }
        }
        func barRightPadding(plans: [PlanData], index: Int, isBarFromEnd: (left: Bool, right: Bool)) -> some View {
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
        func calculateIsBarFromEnd(plan: PlanData) -> (Bool, Bool) {
            var result: (left: Bool, right: Bool) = (false, false)
            if dayNumsInWeek.first! > plan.startDay {
                result.left = true
            } else if dayNumsInWeek.last! < plan.endDay {
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
        let mainDaySectionWidth = 50.responsibleWidth
        let dayNumberRowFrameHeight = 60.responsibleWidth
        let dayNumberGap = 6.responsibleWidth
        let rowHorizontalPadding = 4.responsibleWidth
        
        let todayCircleDiameter = 8.responsibleWidth
        let solidDayNumberFrameHeight = 13.responsibleWidth
        let todayBackgroundHeight = 45.responsibleWidth
        let todayBackgroundWidth = 32.responsibleWidth
        
        let thisWeekDates: [Date] = selectedMonthDate.weekDates(weekOfMonth)
        
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
        
        #warning("이상 있는 날짜 분기처리")

        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                rowLeftEndSpacer()
                ForEach(thisWeekDates, id: \.self) { date in
                    let isToday = (date.day == Date().day && date.month == Date().month && date.year == Date().year)
                    NavigationLink(value: date) {
                        VStack(spacing: 0) {
                            if isToday {
                                Circle()
                                    .scaledToFit()
                                    .frame(width: todayCircleDiameter)
                                    .foregroundStyle(Color.defaultText_wh)
                                    .frame(height: solidDayNumberFrameHeight)
                                    .padding(.bottom, dayNumberGap)
                            } else {
                                let diffDates: Int = {
                                    switch user.displayDateType {
                                    case .birth:
                                        return Date.diffDate(from: user.babyBirthDate, to: date)
                                    case .solid:
                                        return Date.diffDate(from: user.solidStartDate, to: date)
                                    }
                                }()
                                Text("\(diffDates)")
                                    .weekDisplayFont1()
                                    .foregroundStyle(Color.tertinaryText)
                                    .frame(height: solidDayNumberFrameHeight)
                                    .padding(.bottom, dayNumberGap)
                            }
                            Text("\(date.day)")
                                .dayDisplayFont2()
                                .foregroundStyle(isToday ? Color.defaultText_wh : Color.tertinaryText)
                        }
                    }.frame(width: mainDaySectionWidth)
                        .if(isToday) { view in
                            view.background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor2)
                                    .frame(width: todayBackgroundWidth, height: todayBackgroundHeight)
                            }
                        }
                    
//                    NavigationLink {
//                        let mealPlans = mealPlansOB.getMealPlans(in: date)
//                        if mealPlans.count != .zero {
//                            DailyPlanListView(date: date, mealPlans: mealPlans)
//                        } else {
//                            MealDetailView(startDate: date, cycleGap: user.planCycleGap, mealPlansOB: mealPlansOB)
//                        }
//                    } label: {
//                       
//                    }
                }
                rowRightEndSpacer()
            }.frame(height: dayNumberRowFrameHeight)
            calendarDivider
        }
    }
    
    private var monthlyHeader: some View {
        LeftRightButtonHeader(
            leftButton: Button {
                isMyPageOpenning = true
            } label: {
                Image(.userInfo)
            }
            .navigationDestination(isPresented: $isMyPageOpenning) {
                MypageRootView()
            },
            rightButton: Button {
                showWeekly = true
            } label: {
                Image(.calendarInMonthly)
            }
        )
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
                            .weekDisplayFont2()
                            .foregroundStyle(Color.tertinaryText)
                            .frame(width: mainDaySectionWidth)
                            .padding(.leading, mainHorizontalPadding)
                    } else if i == 6 {
                        Text(weekDayKorList[i])
                            .weekDisplayFont2()
                            .foregroundStyle(Color.tertinaryText)
                            .frame(width: mainDaySectionWidth)
                            .padding(.trailing, mainHorizontalPadding)
                    } else {
                        Text(weekDayKorList[i])
                            .weekDisplayFont2()
                            .foregroundStyle(Color.tertinaryText)
                            .frame(width: mainDaySectionWidth)
                    }
                }
            }.frame(height: weekDayRowFrameHeight)
            calendarDivider
        }
    }
    
    private var calendarDivider: some View {
        Rectangle().frame(height: 1).foregroundColor(.listStrokeColor)
    }
    
    private var calendarCurrentYearMonth: some View {
        var solidAndBirthDateText: String {
            if user.displayDateType == .birth {
//                return "생후 \(Date.componentsBetweenDates(from: user.babyBirthDate, to: Date()).day!)일차"
                return "생후 \(Date.diffDate(from: user.babyBirthDate, to: Date()))일차"
            } else {
//                return "이유식 진행 \(Date.componentsBetweenDates(from: user.solidStartDate, to: Date()).day!)일차"
                return "이유식 진행 \(Date.diffDate(from: user.solidStartDate, to: Date()))일차"
            }
        }
        
        return HStack(spacing: 0) {
            Button {
                showChangeMonthModal = true
            } label: {
                Text("\(selectedMonthDate.year.description)년 \(selectedMonthDate.month)월")
                    .headerFont2()
                    .foregroundStyle(Color.defaultText)
                    .padding(.trailing, 2)
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.defaultText)
            }
            
            Spacer()
            
            Text(solidAndBirthDateText)
                .bodyFont3()
                .foregroundStyle(Color.primeText)
                .symmetricBackground(HPad: 12, VPad: 7.5, color: Color.buttonBgColor, radius: 8)
        }
    }
}

extension MonthlyPlanningView {
    enum BarPosition: Int {
        case first = 1
        case second = 2
    }
    
    private func adjustPlanDataDays(plans: inout [PlanData]) {
        let nowMonthFirstDate = selectedMonthDate.monthDates().first!
//        let nextMonthFirstDate = Date.date(year: nowMonthFirstDate.year, month: nowMonthFirstDate.month + 1, day: 1)
        let nextMonthFirstDate = selectedMonthDate.monthDates().last!.add(.day, value: 1)
        
        for i in plans.indices {
            var plan = plans[i]
            
            if plan.mealPlan.endDate.timeIntervalSince1970 >= nextMonthFirstDate.timeIntervalSince1970 {
                plan.endDay += Date.nowMonthDates().count
            }
            if plan.mealPlan.startDate.timeIntervalSince1970 <= nowMonthFirstDate.timeIntervalSince1970 {
                plan.startDay -= nowMonthFirstDate.add(.day, value: -1).monthDates().count
            }
            
            plans[i] = plan
        }
    }
    
    private func reducePlanData(plans: [PlanData]) -> [(PlanData, BarPosition)] {
        let nowMonthDates = Date.nowMonthDates()
        let lastDateNum = nowMonthDates.last!.day
        // key는 -7 ~ 마지막일+7 까지의 Int형 정수, value는 (first: Bool, second: Bool)인 tuple로 이루어진 dictionary
        // ex: { 1: (true, false), 2: (true, false)... }  (true가 가용한(비어있는) 상태)
        var dict = Dictionary(uniqueKeysWithValues: (-32...lastDateNum+32).map { ($0, (first: true, second: true)) })
        
        var result: [(PlanData, BarPosition)] = []
        
        // 시작일 순 정렬
        let sortedPlans = plans.sorted{ $0.startDay < $1.startDay }
        
        for plan in sortedPlans {
            var isPlanAcceptedOnFirstLine = true
            var isPlanAcceptedOnSecondLine = true
            
            for i in Range<Int>(plan.startDay...plan.endDay) {
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
                for i in Range<Int>(plan.startDay...plan.endDay) {
                    dict[i]!.first = false
                }
                result.append((plan, .first))
            } else if isPlanAcceptedOnSecondLine {
                // 첫 줄에 가능한 지 우선 체크 후 둘째 줄을 체크
                for i in Range<Int>(plan.startDay...plan.endDay) {
                    dict[i]!.second = false
                }
                result.append((plan, .second))
            }
        }
        
        return result.sorted { $0.0.startDay < $1.0.startDay }    // startDate 순 정렬
    }
    
    private func reducePlanDataInWeek(weekOfMonth: Int,
                                      reducedPlans: [(first: PlanData, second: BarPosition)])
    -> [(PlanData, BarPosition)] {
        let dayNumsInWeek: [Int] = selectedMonthDate.weekDates(weekOfMonth).map{ $0.day }
        var result: [(PlanData, BarPosition)] = []
        
        for plan in reducedPlans.sorted(by: { $0.0.startDay < $1.0.startDay }) {
            if dayNumsInWeek.contains(plan.first.startDay) ||
                dayNumsInWeek.contains(plan.first.endDay) {
                result.append(plan)
            }
        }
        return result.sorted { $0.0.startDay < $1.0.startDay }    // startDate 순 정렬
    }
}
