//
//  MealGroupView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

// TODO: - 새로운 재료는 accentColor1로 색 바꾸기
// TODO: - mealGroup 눌렀을 때 action - PlanDetailView로 이동해야 함
// TODO: - meal 눌렀을 때 action - MealDetailView로 이동해야 함
// 사용되는 뷰
//   PlanListView, DailyListView

import SwiftUI

// MARK: - MealGroupView

struct MealGroupView: View {
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    let mealPlanGroup: MealPlanGroup
    
    let isInPlanList: Bool
    let isTodayInDateRange: Bool
    
    private let texts = TextLiterals.MealGroup.self
    let action: () -> ()

    init(
        mealPlanGroup: MealPlanGroup,
        isInPlanList: Bool = true,
        isTodayInDateRange: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.mealPlanGroup = mealPlanGroup
        self.isInPlanList = isInPlanList
        self.isTodayInDateRange = isTodayInDateRange
        self.action = action
    }

    var body: some View {
        VStack(spacing: K.wholeVStackSpacing) {
            dateInformation
            mealGroup
        }
        .navigationDestination(for: MealPlan.self) { mealPlan in
            MealDetailView(
                mealPlan: mealPlan,
                cycleGap: mealPlan.cycleGap,
                mealPlansOB: mealPlansOB
            )
        }
    }
    
    private var dateInformation: some View {
        // planList이면서 wrong plan이라면 noti circle이 보인다.
        let showNotiCircle = isInPlanList && isWrongPlan
        return HStack(alignment: .bottom, spacing: K.dateInformationHStackSpacing) {
            if showNotiCircle { notiCircle }
            Text(dateRange)
                .customFont(.dayDisplay1, color: K.dayDisplayTextColor)
            Spacer()
            DisplayDateInfoView(from: startDate, to: endDate)
        }
    }
}

extension MealGroupView {
    var dateRange: String { mealPlanGroup.solidDate.description }
    var startDate: Date { mealPlanGroup.solidDate.startDate }
    var endDate: Date { mealPlanGroup.solidDate.endDate }
    var mealPlans: [MealPlan] { mealPlanGroup.sortedMealPlans }
    var isWrongPlan: Bool { mealPlanGroup.isWrong }
}

// MARK: - date Information

extension MealGroupView {
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

// MARK: - meal group

extension MealGroupView {
    private var mealGroup: some View {
        VStack(spacing: .zero) {
            let lastIndex = mealPlans.indices.last
            let sortedMealPlans = Array(mealPlans.sorted(by: { $0.mealType.rawValue < $1.mealType.rawValue }).enumerated())
            ForEach(sortedMealPlans, id:\.element) { index, mealPlan in
                mealView(of: mealPlan)
                if index != lastIndex {
                    mealDivider
                }
            }
        }
        .background(backgroundRectangle)
        .clipped()
    }


    private func mealView(of mealPlan: MealPlan) -> some View {
        // PlanListView에서는 전체가 눌린다.
        // DailyListView에서는 끼니 별로 눌린다.

        NavigationLink(value: mealPlan) {
            HStack {
                mealIcon(of: mealPlan)
                ColoredIngredientsText(mealPlan: mealPlan, type: .cell)
                Spacer()
                if isInPlanList == false {
                    Image(.rightChevronSmall)
                }
            }
            .padding(
                top: K.MealView.padding,
                leading: K.MealView.padding,
                bottom: K.MealView.padding,
                trailing: K.MealView.trailingPadding
            )
            .frame(minHeight: K.MealView.minHeight)
            
        }
        .disabled(isInPlanList)
    }

    private var mealDivider: some View {
        Rectangle()
            .padding(.horizontal, isInPlanList ? K.Divider.inListPadding : K.Divider.notInListPadding )
            .frame(height:K.Divider.height)
            .foregroundStyle(K.Background.strokeNormalColor)
    }

    private var backgroundRectangle: some View {
        let isStrokeHighlight = isInPlanList && isTodayInDateRange
        return RoundedRectangle(cornerRadius: K.Background.rectangleRadius)
            .fill(.white,
                  strokeBorder: isStrokeHighlight ? K.Background.highlightStrokeColor : K.Background.strokeNormalColor,
                  lineWidth: K.Background.strokeLineWidth)
    }
}

// MARK: - Meal View

extension MealGroupView {
    private func mealIcon(of mealPlan: MealPlan) -> some View {
        Image(systemName: mealPlan.mealType.icon)
            .font(.body)
            .foregroundStyle(Color.accentColor2)
    }
}

// MARK: - AddNewMealView

struct AddNewMealView: View {
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    var startDate: Date
    var endDate: Date
    @State private var isMealAdding: Bool = false
    
    var body: some View {
        Button {
            isMealAdding = true
        } label: {
            VStack(spacing: K.wholeVStackSpacing) {
                dateInformation
                addIngredientButton
            }
            .padding(.bottom, K.AddNewPlan.bottomPadding)
        }
        .navigationDestination(isPresented: $isMealAdding) {
            MealDetailView(
                startDate: startDate,
                endDate: endDate,
                mealPlansOB: mealPlansOB
            )
        }
    }
    
    private var dateInformation: some View {
        let dateRange = TextLiterals.PlanList.dateRangeString(start: startDate, end: endDate)

        return HStack(alignment: .bottom, spacing: K.dateInformationHStackSpacing) {
            Text(dateRange)
                .customFont(.dayDisplay1, color: K.dayDisplayTextColor)
            Spacer()
            DisplayDateInfoView(from: startDate, to: endDate)
        }
    }
    
    private var addIngredientButton: some View {
        HStack {
            Text(TextLiterals.MealGroup.addIngredientText)
                .customFont(.header5, color: K.AddNewPlan.textColor)
            Spacer()
            Image(.rightChevronSmall)
        }
        .padding()
        .frame(height: K.AddNewPlan.height)
        .foregroundStyle(K.AddNewPlan.textColor)
        .withRoundedBackground(
            cornerRadius: K.Background.rectangleRadius,
            fill: Color.defaultText_wh,
            strokeBorder: K.Background.strokeNormalColor,
            lineWidth: K.Background.strokeLineWidth
        )
    }
    
    private var chevron: some View {
        Image(.rightChevronSmall)
            .foregroundStyle(K.Chevron.color)
    }
}


fileprivate enum K {
    static var wholeVStackSpacing: CGFloat { 16 }
  
    // mealview
    enum MealView {
        static var padding: CGFloat { 18 }
        static var minHeight: CGFloat { 64 }
        static var trailingPadding: CGFloat { 12 }
    }
    // background
    
    // dateInformation
    static var dayDisplayTextColor: Color { .defaultText.opacity(0.4) }
    static var notiCircleSize: CGFloat { 6 }
    static var dateInformationHStackSpacing: CGFloat { 6 }

    // meal group
    enum Divider {
        static var inListPadding: CGFloat { 19 }
        static var notInListPadding: CGFloat { -30 }
        static var height: CGFloat { 1.4 }
    }
    
    enum Chevron {
        static var rightSFSymbolName: String { "chevron.right" }
        static var color: Color { .quarternaryText }
    }
    
    enum Background {
        static var rectangleRadius: CGFloat { 12 }
        static var strokeNormalColor: Color { .listStrokeColor }
        static var highlightStrokeColor: Color { .accentColor1 }
        static var strokeLineWidth: Double { 2 }
    }
    enum AddNewPlan {
        static var textColor: Color { .defaultText.opacity(0.6) }
        static var height: Double { 64 }
        static var bottomPadding: Double { 6 }
    }
    
}
