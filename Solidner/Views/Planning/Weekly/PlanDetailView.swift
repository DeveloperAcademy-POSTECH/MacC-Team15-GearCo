//
//  PlanDetailView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//
/**
 -[x] 플랜에 대한 경고 필요
 -[ ] cell을 누르면 해당 meal에 대한 detail로 넘어간다
 ## CRUD
 -[ ] 끼니 추가 버튼으로 끼니 추가
 -[ ] 6끼라면 버튼 disable 안함. 대신 끼니 추가 후 wrongplan 경고뷰가 나옴
 -[x] 편집을 누르면 드래거블
 -[ ] toolbar를 커스텀으로 할 것인가 말 것인가 :)
 */
import SwiftUI

struct PlanDetailView: View {
    @EnvironmentObject private var user: UserOB
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var mealPlans: [MealPlan]
    @State private var isEditMode: Bool = false
    // TODO: - 나중에 어떻게 선언해야할지 고민 State? Binding? 계획이 바뀌었을 때, 바뀐 계획에 따라서 값이 바뀌어야함.
    private(set) var isWrongPlan: Bool = true

    private let texts = TextLiterals.PlanDetail.self
    private enum K {
        static var wholeVStackSpacing: CGFloat { 26 }
    }
    private var dateRangeString: String { texts.dateRangeString(start: startDate, end: endDate) }

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(spacing: K.wholeVStackSpacing) {
                        header
                        if isWrongPlan { WarningView() }
                        DraggableMealGroupView(
                            dateRange: dateRangeString,
                            displayDateInfo: DisplayDateInfoView(from: startDate, to: endDate),
                            mealPlans: $mealPlans,
                            isEditMode: $isEditMode
                        )
                        Spacer()
                    }
                }
                addMealButton
            }
            .toolbar {
                toolbarItemLeading
                toolbarItemTrailing
            }
        }
    }
}


// toolbar

extension PlanDetailView {

    private var toolbarItemLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image(assetName: .headerChevron)
        }
    }

    private var toolbarItemTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isEditMode.toggle()
            } label: {
                Text(isEditMode ? "편집" : "완료")
                    .modify { view in
                        if(isEditMode) {
                            view.bodyFont1()
                                .foregroundStyle(Color.defaultText.opacity(0.3))
                        } else {
                            view
                                .headerFont5()
                                .foregroundStyle(Color.accentColor1)
                        }
                    }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            Text(texts.dateRangeTitle(from: startDate, to: endDate))
                .headerFont2()
            Spacer()
        }
    }

    // TODO: - add meal action
    private var addMealButton: some View {
        ButtonComponents(.big, title: texts.addMeal) {
            print(#function)
        }
        .buttonColor(Color.buttonBgColor)
        .titleColor(Color.secondaryText)
    }
}


struct PlanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDetailView(startDate: .constant(Date()), endDate: .constant(Date()), mealPlans: .constant(Array(MealPlan.mockMealsOne[0...3])))
            .environmentObject(UserOB())
    }
}
