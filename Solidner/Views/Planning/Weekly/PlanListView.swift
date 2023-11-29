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
 -[x] 이유식/월령 바꾸기
 -[x] 이유식 날짜 보이기
 -[x] 셀 1개
 -[x] 그룹
 -[ ] date scroll에서 이상 반응 보이게
 -[ ] read only 구현
 */
// TODO: - date 각 년월일 들어가게 :)
// TODO: - 문제있는 date만 표시될 수 있도록 새로운 struct를 선언해야 할까?
// TODO: - date 버튼 눌렀을 때 화면 전환 action
// TODO: - totalSetting으로 화면 전환

import SwiftUI

struct PlanListView: View {
    @EnvironmentObject private var user: UserOB
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    
    @Binding var showWeekly: Bool
    
    @State private var selectedDate = Date()
    @State private var isCurrentDateEditing = false
    @State private var isWholeSettingEditing = false
    @State private var isMyPageOpenning = false
    
    var mealPlans: [MealPlan] { mealPlansOB.filteredMealPlans }
    var mealPlanGroups: [MealPlanGroup] { mealPlansOB.mealPlanGroups }
    
    private let texts = TextLiterals.PlanList.self
    
    var body: some View {
        RootVStack {
            viewHeader
            viewBody
        }
    }
    
    private var viewHeader: some View {
        return LeftRightButtonHeader(
            leftButton: headerLeftButton,
            rightButton: headerRightButton
        )
    }
    
    private var viewBody: some View {
        ScrollView {
            VStack(spacing: K.rootVStackSpacing) {
                titleHeader
                dateScroll
                ThickDivider()
                mealGroupList
                ThickDivider()
                totalSetting
            }
            .defaultHorizontalPadding()
        }
        .sheet(isPresented: $isCurrentDateEditing) {
            ChangeMonthHalfModal(
                selectedDate: $selectedDate,
                fromDate: user.babyBirthDate
            )
        }
        .onChange(of: selectedDate) { value in
            mealPlansOB.currentFilter = .month(date: value)
            print(mealPlansOB.currentFilter)
        }
        .navigationDestination(isPresented: $isMyPageOpenning) {
            MypageRootView()
        }
        .navigationDestination(for: Date.self) { date in
            let mealPlans = mealPlansOB.getMealPlans(in: date)
            if mealPlans.count != .zero {
                DailyPlanListView(date: date, mealPlans: mealPlans)
            } else {
                MealDetailView(startDate: date, cycleGap: user.planCycleGap)
            }
        }
    }
}

// MARK: - View Header
extension PlanListView {
    private var headerLeftButton: some View {
        Button {
            isMyPageOpenning = true
        } label: {
            Image(.userInfo)
        }
    }
    private var headerRightButton: some View {
        Button {
            showWeekly = false
        } label: {
            Image(.calendarInPlanList)
        }
    }
}

// MARK: - title Header
extension PlanListView {
    private var titleHeader: some View {
        Button {
            isCurrentDateEditing.toggle()
        } label: {
            HStack(spacing: K.titleHStackSpacing) {
                Text(texts.yyyymmHeaderText(date: selectedDate))
                    .customFont(.header2, color: K.titleTextColor)
                Image(systemName: K.chevronDownSFSymbolName)
                    .foregroundStyle(K.chevronDownColor)
                    .bold()
                Spacer()
            }
        }
        .padding(K.titlePadding)
    }
}

// MARK: - date Scroll
extension PlanListView {
    private var dateScroll: some View {
        let spacer: some View = Spacer()
            .frame(width: K.defaultHorizontalPadding - K.dateHStackSpacing)
        
        return ScrollView(.horizontal) {
            HStack(spacing: K.dateHStackSpacing) {
                spacer
                ForEach(mealPlansOB.getWrongPlanDates(date: selectedDate)) { dateAndStatus in
                    let date = dateAndStatus.date
                    NavigationLink(value: date){
                        dateScrollLabel(of: dateAndStatus)
                    }
                }
                spacer
            }
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, -K.defaultHorizontalPadding)
    }
    
//    private func dateScrollLabel(of date: Date, _ isWrong: Bool) -> some View {
    private func dateScrollLabel(of dateAndStatus: DateAndPlanStatus) -> some View {
        let (date, isWrong) = (dateAndStatus.date, dateAndStatus.isPlanWrong)
        return HStack{
            if isWrong { notiCircle }
            Text(texts.ddDateText(date: date))
                .customFont(.header6, color: .primeText)
        }
            .frame(width: K.dateButtonWidth, height: K.dateButtonHeight)
            .withRoundedBackground(
                cornerRadius: K.dateButtonCornerRadius,
                color: K.dateButtonBackgroundColor
            )
    }
    
    private var notiCircle: some View {
        VStack {
            Spacer()
            Circle()
                .frame(width: K.notiCircleSize, height: K.notiCircleSize)
                .foregroundStyle(Color.accentColor1)
            Spacer()
        }
    }
}

// MARK: - meal Group List
extension PlanListView {
    private var mealGroupList: some View {
        VStack(spacing: K.mealGroupListVStackSpacing) {
            ForEach(mealPlansOB.mealPlanGroups, id: \.self) { mealPlanGroup in
                let (startDate, endDate) = (mealPlanGroup.solidDate.startDate, mealPlanGroup.solidDate.endDate)
                NavigationLink(value: mealPlanGroup) {
                    MealGroupView(
                        mealPlanGroup: mealPlanGroup,
                        isTodayInDateRange: Date().isInBetween(from: startDate, to: endDate)
                    )
                }
            }
            addNewMealPlan
        }
        .navigationDestination(for: MealPlanGroup.self) { mealPlanGroup in
            PlanGroupDetailView(mealPlanGroup: mealPlanGroup)
        }
    }
    
    @ViewBuilder
    private var addNewMealPlan: some View {
        let one = 1
        let newStartDate: Date = {
            let nextDateOfLastPlan = mealPlans.sorted { $0.endDate > $1.endDate }.first?.endDate.add(.day, value: one)
            let firstOfThisMonth = Date.date(year: selectedDate.year, month: selectedDate.month, day: one)!
            return max(user.solidStartDate, (nextDateOfLastPlan ?? firstOfThisMonth))
        }()
        if newStartDate.month != selectedDate.month {
            EmptyView()
        } else {
            let newEndDate = newStartDate.add(.day, value: user.planCycleGap.rawValue - one)
            AddNewMealView(startDate: newStartDate, endDate: newEndDate)
        }
    }
}

// MARK: - totalSetting
extension PlanListView {
    private var totalSetting: some View {
        Button {
            isWholeSettingEditing = true
        } label: {
            HStack {
                Text(texts.solidTotalSettingText)
                    .customFont(.header4, color: K.solidTotalSettingTextColor)
                Spacer()
                Image(systemName: K.chevronRightSFSymbolName)
                    .foregroundStyle(K.chevronRightColor)
                    .bold()
            }
        }
        .navigationDestination(isPresented: $isWholeSettingEditing) {
            PlanBatchSettingView()
        }
    }
}

extension PlanListView {
    private enum K {
        static var rootVStackSpacing: CGFloat { 26 }
        static var defaultHorizontalPadding: CGFloat { 20 }
        
        static var titleHStackSpacing: CGFloat { 4 }
        static var titlePadding: EdgeInsets { .init(top: 21, leading: 0, bottom: 0, trailing: 0) }
        static var titleTextColor: Color { .defaultText }
        static var chevronDownSFSymbolName: String { "chevron.down" }
        static var chevronDownColor: Color { .primeText }
        
        static var dateHStackSpacing: CGFloat { 12 }
        static var dateTextColor: Color { .secondaryText }
        static var dateButtonWidth: CGFloat { 70 }
        static var dateButtonHeight: CGFloat { 36 }
        static var dateButtonCornerRadius: CGFloat { 12 }
        static var dateButtonBackgroundColor: Color { .buttonBgColor }
        static var notiCircleSize: CGFloat { 6 }
        
        static var mealGroupListVStackSpacing: CGFloat { 40 }
        
        static var chevronRightSFSymbolName: String { "chevron.right" }
        static var chevronRightColor: Color { .primeText }
        
        static var solidTotalSettingTextColor: Color { .primeText }
    }
}
