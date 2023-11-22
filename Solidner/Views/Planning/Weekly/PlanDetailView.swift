//
//  PlanDetailView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//
/**
 -[ ] 플랜에 대한 경고 필요
 -[ ] cell을 누르면 해당 meal에 대한 detail로 넘어간다
## CRUD
 -[ ] 끼니 추가 버튼으로 끼니 추가
    -[ ] 6끼라면 버튼 disable
 -[ ] 일정 전체 삭제
 -[ ] 편집을 누르면 드래거블
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
    private var dateRangeString: String {
        TextLiterals.PlanList.dateRangeString(start: startDate, end: endDate)
    }

    var body: some View {
        VStack {
            header
            if isWrongPlan {
                WarningView()
            }
            MealGroupView(
                dateRange: dateRangeString,
                displayDateInfo: user.displayDateType.textInfo(of: user, from: startDate, to: endDate),
                mealPlans: mealPlans,
                isInList: false
            )
            Spacer()
            addMealButton
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            Text(texts.dateRangeTitle(from: startDate, to: endDate))
            Spacer()
            Button {
                isEditMode.toggle()
            } label: {
                Text(isEditMode ? texts.deletePlan : texts.editPlan)
            }
        }
    }

    // TODO: - Warning 정의 및 literal 정의

    private var warningView: some View {
        VStack {
            // 어찌구 아이콘
            Text(texts.existsDuplicatedMeal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.gray)
        )
    }

    private var addMealButton: some View {
        Button {
            print(#function)
        } label: {
            ButtonComponents(.big, title: texts.addMeal)
        }
    }
}

//#Preview {
//    PlanDetailView(startDate: .constant(Date()), endDate: .constant(Date()), mealPlans: .constant(Array(MealPlan.mockMealsOne[0...3])))
//}
