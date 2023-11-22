//
//  MealGroupView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

import SwiftUI

struct MealGroupView<Content>: View where Content: View {
    enum MealGroupViewType {
        case normal, addNew
    }
    let type: MealGroupViewType
    let dateRange: String
    let displayDateInfo: Content
    let mealPlans: [MealPlan]
    let isFoodDate: Bool
    let isInList: Bool
    let isTodayInDateRange: Bool

    init(
        type: MealGroupViewType = .normal,
        dateRange: String,
        displayDateInfo: Content = EmptyView(),
        mealPlans: [MealPlan] = [],
        isFoodDate: Bool = false,
        isInList: Bool = true,
        isTodayInDateRange: Bool = false
    ) {
        self.type = type
        self.dateRange = dateRange
        self.displayDateInfo = displayDateInfo
        self.mealPlans = mealPlans
        self.isFoodDate = isFoodDate
        self.isInList = isInList
        self.isTodayInDateRange = isTodayInDateRange
    }

    var body: some View {
        VStack {
            dateInformation
            if isInList {
                Button {
                    print(#function)
                } label: {
                    if type == .normal {
                        mealGroup
                    } else {
                        addNewMealPlan
                    }
                }
            } else {
                mealGroup
            }
        }
    }

    private var dateInformation: some View {
        HStack {
            Text(dateRange)
            Spacer()
            displayDateInfo
        }
    }

    private var mealGroup: some View {
        VStack(spacing: .zero) {
            let lastIndex = mealPlans.indices.last
            ForEach(Array(mealPlans.sorted(by: { $0.mealType.rawValue < $1.mealType.rawValue }).enumerated()), id:\.element) { index, mealPlan in
                if isInList {
                    mealViewInList(of: mealPlan)
                } else {
                    mealViewNotInList(of: mealPlan)
                }

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

    private func mealViewNotInList(of mealPlan: MealPlan) -> some View {
        Button {
            print(#function)
        } label: {
            HStack {
                Image(systemName: mealPlan.mealType.icon)
                    .font(.body)
                Text(mealPlan.ingredientsString)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .frame(height: 55)
    }

    private func mealViewInList(of mealPlan: MealPlan) -> some View {
        HStack {
            Image(systemName: mealPlan.mealType.icon)
                .font(.body)
            Text(mealPlan.ingredientsString)
            Spacer()
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

struct MealGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MealGroupView(dateRange: "25일(일) ~ 28일(화)", mealPlans: Array(MealPlan.mockMealsOne[0...5]), isTodayInDateRange: true)
    }
}
