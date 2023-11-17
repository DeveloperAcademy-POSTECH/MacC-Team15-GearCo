//
//  MealGroupView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

import SwiftUI

struct MealGroupView: View {
    enum MealGroupViewType {
        case normal, addNew
    }
    let type: MealGroupViewType
    let dateRange: String
    let mealPlans: [MealPlan]
    let isFoodDate: Bool
    let isInList: Bool
    let isTodayInDateRange: Bool

    init(
        type: MealGroupViewType = .normal,
        dateRange: String,
        mealPlans: [MealPlan] = [],
        isFoodDate: Bool = false,
        isInList: Bool = true,
        isTodayInDateRange: Bool = false
    ) {
        self.type = type
        self.dateRange = dateRange
        self.mealPlans = mealPlans
        self.isFoodDate = isFoodDate
        self.isInList = isInList
        self.isTodayInDateRange = isTodayInDateRange
    }

    var body: some View {
        VStack {
            dateInformation
            Button {

            } label: {
                if type == .normal {
                    mealGroup
                } else {
                    addNewMealPlan
                }
            }
        }
    }

    private var dateInformation: some View {
        HStack {
            Text(dateRange)
            Spacer()
            Image(systemName: isFoodDate ? "leaf.fill" : "figure.arms.open")
            Text("이유식 며칠차")
        }
    }

    private var mealGroup: some View {
        VStack(spacing: .zero) {
            let lastIndex = mealPlans.indices.last
            ForEach(Array(mealPlans.sorted(by: { $0.mealType.rawValue < $1.mealType.rawValue }).enumerated()), id:\.element) { index, mealPlan in
                mealView(of: mealPlan)
                if index != lastIndex {
                    Divider()
                        .padding(.horizontal, isInList ? .zero : -30 )
                }
            }
            .foregroundStyle(Color.black)
            .padding(.horizontal)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isTodayInDateRange ? .green : .white,
                      strokeBorder: .gray,
                      lineWidth: 1)
        )
        .clipped()
    }

    private func mealView(of mealPlan: MealPlan) -> some View {
        HStack {
            Image(systemName: mealPlan.mealType.icon)
                .font(.body)
            Text(mealPlan.ingredientsString)
            Spacer()
            if isInList == false {
                Image(systemName: "chevron.right")
            }
        }
        .frame(height: 55)
    }

    private var addNewMealPlan: some View {
        HStack {
            Text("재료 추가")
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .foregroundStyle(Color.black)
        .frame(height: 55)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white,
                      strokeBorder: .gray,
                      lineWidth: 1)
        )
    }
}

#Preview {
    MealGroupView(dateRange: "25일(일) ~ 28일(화)", mealPlans: Array(MealPlan.mockMealsOne[0...5]), isTodayInDateRange: true)
}
