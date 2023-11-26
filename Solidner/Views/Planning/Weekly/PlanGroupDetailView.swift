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
    
    private let texts = TextLiterals.PlanDetail.self
    let startDate: Date
    let mealPlanGroup: MealPlanGroup
    
    
    init(mealPlanGroup: MealPlanGroup) {
        self.mealPlanGroup = mealPlanGroup
        self._tempMealPlanGroup = State(initialValue: mealPlanGroup)
        self.startDate = mealPlanGroup.solidDate.startDate
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            viewHeader
            viewBody
        }
        .withClearBackground(color: .secondBgColor)
        .navigationBarBackButtonHidden()
    }
    
    private var viewHeader: some View {
        BackButtonAndRightHeader(rightButton: viewHeaderRightButton)
    }
    
    private var viewBody: some View {
        VStack(spacing: .zero) {
            ScrollView {
                VStack(spacing: K.wholeVStackSpacing) {
                    headerTitle
                    if isWrongPlan { WarningView() }
                    DraggableMealGroupView(
                        dateRange: dateRangeString,
                        displayDateInfo: DisplayDateInfoView(from: startDate, to: endDate),
                        mealPlans: $tempMealPlanGroup.mealPlans,
                        isEditMode: $isEditMode
                    )
                    Spacer()
                }
            }
            addMealButton
        }
        .navigationDestination(isPresented: $isMealAdding) {
            MealDetailView(
                startDate: startDate,
                endDate: endDate
            )
        }
        .defaultHorizontalPadding()
    }
}

extension PlanGroupDetailView {
    private var viewHeaderRightButton: some View {
        Button {
            if isEditMode {
                mealPlansOB.updateMealPlan(in: tempMealPlanGroup)
            }
            isEditMode.toggle()
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
    
    // TODO: - add meal action
    private var addMealButton: some View {
        ButtonComponents(.big, title: texts.addMeal) {
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

struct PlanDetailView_Previews: PreviewProvider {
    static var mealPlansOB = MealPlansOB(mealPlans: MealPlan.mockMealsOne)
    static var previews: some View {
        let mealPlanGroup = MealPlanGroup(mealPlans: Array(MealPlan.mockMealsOne[0...3]))
        PlanGroupDetailView(mealPlanGroup: mealPlanGroup)
//        PlanGroupDetailView(mealPlansOB: mealPlansOB)
            .environmentObject(UserOB())
            .environmentObject(MealPlansOB())
    }
}
