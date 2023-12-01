//
//  PlanGroupDetailView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//
/**
 -[x] 플랜에 대한 경고 필요
 -[ ] cell을 누르면 해당 meal에 대한 detail로 넘어간다
 ## CRUD
 ## CRUD
 -[ ] 끼니 추가 버튼으로 끼니 추가
 -[ ] 6끼라면 버튼 disable 안함. 대신 끼니 추가 후 wrongplan 경고뷰가 나옴
 -[x] 편집을 누르면 드래거블
 */
import SwiftUI

struct PlanGroupDetailView: View {
    @EnvironmentObject private var user: UserOB
    @EnvironmentObject private var mealPlansOB: MealPlansOB

    @State private var isMealAdding: Bool = false
    @State private var tempMealPlanGroup: MealPlanGroup
    @State private var isEditMode: Bool = false
    
    private let texts = TextLiterals.PlanGroupDetail.self
    let startDate: Date
    let mealPlanGroup: MealPlanGroup
    
    init(mealPlanGroup: MealPlanGroup) {
        self.mealPlanGroup = mealPlanGroup
        self._tempMealPlanGroup = State(initialValue: mealPlanGroup)
        self.startDate = mealPlanGroup.solidDate.startDate
    }
    
    var body: some View {
        RootVStack {
            viewHeader
            viewBody
        }
    }
    
    @ViewBuilder
    private var viewHeader: some View {
        if isEditMode {
            RightButtonOnlyHeader(rightButton: viewHeaderRightButton)
        } else {
            BackButtonAndRightHeader(rightButton: viewHeaderRightButton)
        }
    }
    
    private var viewBody: some View {
        VStack(spacing: .zero) {
            if tempMealPlanGroup.mealPlans.isEmpty {
                VStack {
                    headerTitle
                    emptyView
                }
            } else {
                ScrollView {
                    VStack(spacing: K.wholeVStackSpacing) {
                        headerTitle
                        if isWrongPlan { WarningView() }
                        mealGroup
                        Spacer()
                    }
                }
            }
            addMealButton
        }
        .defaultViewBodyTopPadding()
        .defaultHorizontalPadding()
        .navigationDestination(isPresented: $isMealAdding) {
            MealDetailView(
                startDate: startDate,
                endDate: endDate,
                mealPlansOB: mealPlansOB
            )
        }
        .onChange(of: mealPlansOB.filteredMealPlans) { _ in
            let solid = tempMealPlanGroup.solidDate
            let plans = mealPlansOB.getMealPlans(from: solid.startDate, to: solid.endDate)
            if let firstMealPlanGroup = MealPlanGroup.build(with: plans).first {
                tempMealPlanGroup = firstMealPlanGroup
            } else {
                tempMealPlanGroup = MealPlanGroup(solidDate: tempMealPlanGroup.solidDate, mealPlans: [])
            }
        }
    }
}

// TODO: - 매직 스트링, 매직 넘버 제거
// #warning("매직 스트링, 매직 넘버 제거")
// MARK: - view header

extension PlanGroupDetailView {
    private var viewHeaderRightButton: some View {
        Button {
            if isEditMode {
                mealPlansOB.updateMealPlan(in: tempMealPlanGroup)
            }
            withAnimation {
                isEditMode.toggle()
            }
        } label: {
            Text(isEditMode ? "완료" : "편집")
                .modify { view in
                    if(isEditMode) {
                        view.customFont(.header5, color: .accentColor1)
                    } else {
                        view.customFont(.body1, color: .defaultText.opacity(0.3))
                    }
                }
        }
    }
}

// body

extension PlanGroupDetailView {
    
    private var headerTitle: some View {
        HStack(alignment: .top) {
            Text(texts.dateRangeTitle(from: startDate, to: endDate))
                .headerFont2()
            Spacer()
        }
    }
    
    private var emptyView: some View {
        PlanEmptyView()
            .frame(maxWidth: .infinity)
    }
    
    private var mealGroup: some View {
        DraggableMealGroupView(
            dateRange: dateRangeString,
            displayDateInfo: DisplayDateInfoView(from: startDate, to: endDate),
            mealPlans: $tempMealPlanGroup.mealPlans,
            isEditMode: $isEditMode
        )
    }
    
    private var addMealButton: some View {
        ButtonComponents(
            .big,
            title: texts.addMeal
        ) {
            isMealAdding = true
        }
        .buttonColor(Color.buttonBgColor)
        .titleColor(Color.secondaryText)
    }
}

extension PlanGroupDetailView {
    var endDate: Date { tempMealPlanGroup.solidDate.endDate }
    var mealPlans: [MealPlan] { tempMealPlanGroup.mealPlans }
    var isWrongPlan: Bool { tempMealPlanGroup.isWrong }

    private var dateRangeString: String { texts.dateRangeString(start: startDate, end: endDate) }
    
    private enum K {
        static var wholeVStackSpacing: CGFloat { 26 }
    }
}

#Preview {
    PlanGroupDetailView(mealPlanGroup: .init(solidDate: .init(startDate: Date(), endDate: Date()), mealPlans: []))
        .environmentObject(MealPlansOB())
        .environmentObject(UserOB())
}
