//
//  DraggableMealGroupView.swift
//  Solidner
//
//  Created by sei on 11/17/23.
//

// TODO: - 새로운 재료는 accentColor1로 색 바꾸기
// TODO: - mealGroup 눌렀을 때 action - PlanDetailView로 이동해야 함
// TODO: - meal 눌렀을 때 action - MealDetailView로 이동해야 함

import SwiftUI

struct DraggableMealGroupView<Content>: View where Content: View {
    let dateRange: String
    let displayDateInfo: Content
    
    @Binding private var tempMealPlans: [MealPlan]
    private let texts = TextLiterals.MealGroup.self
    @State private var draggingMealPlan: MealPlan?
    let mealTypeOrder: [MealType]
    @Binding private var isEditMode: Bool

    init(
        dateRange: String,
        displayDateInfo: Content = EmptyView(),
        mealPlans: Binding<[MealPlan]> = .constant([]),
        isEditMode: Binding<Bool> = .constant(false)
    ) {
        self.dateRange = dateRange
        self.displayDateInfo = displayDateInfo
        self._tempMealPlans = mealPlans
        self.mealTypeOrder = mealPlans.wrappedValue.map { $0.mealType }.sorted()
        self._isEditMode = isEditMode
    }

    var body: some View {
        VStack(spacing: K.wholeVStackSpacing) {
            dateInformation
            mealGroup
        }
    }
}

// MARK: - date Information

extension DraggableMealGroupView {
    private var dateInformation: some View {
        return HStack(alignment: .bottom, spacing: K.dateInformationHStackSpacing) {
            Text(dateRange)
                .customFont(.dayDisplay1, color: K.dayDisplayTextColor)
            Spacer()
            displayDateInfo
        }
    }
}

// MARK: - meal group

extension DraggableMealGroupView {
    private var mealGroup: some View {
        VStack(spacing: .zero) {
            let lastIndex = tempMealPlans.indices.last
            ForEach(Array(tempMealPlans.enumerated()), id:\.element) { index, mealPlan in
                mealView(of: mealPlan)
                    .if(isEditMode) { view in
                        view.draggable(mealPlan) {
                            mealView(of: mealPlan)
                                .frame(minWidth: UIScreen.screenWidth*0.8).opacity(0.8)
                                .onAppear() { draggingMealPlan = mealPlan }
                        }
                        .dropDestination(for: MealPlan.self) { _, _ in
                            // drop이 수행되면 식단을 재배열한다.
                            withAnimation { tempMealPlans = correctMealPlansOrder() }
                            return false
                        } isTargeted: { isOver in
                            guard let draggedMealPlan = draggingMealPlan, isOver, draggedMealPlan != mealPlan,
                                  let sourceIndex = tempMealPlans.firstIndex(of: draggedMealPlan),
                                  let destinationIndex = tempMealPlans.firstIndex(of: mealPlan) else { return }
                            // 실제로 VStack 내에서 view를 움직이는 부분
                            withAnimation {
                                tempMealPlans.remove(at: sourceIndex)
                                tempMealPlans.insert(draggedMealPlan, at: destinationIndex)
                            }
                        }
                    }
                if index != lastIndex {
                    mealDivider
                }
            }
        }
        .withRoundedBackground(
            cornerRadius: K.backgroundRectangleRadius,
            fill: Color.defaultText_wh,
            strokeBorder: K.backgroundStrokeNormalColor,
            lineWidth: K.backgroundStrokeLineWidth
        )
        .clipped()
    }

    // 식단을 재배열하기 위해 실행하는 함수. 재배열된 [MealPlan]이 mealPlans를 대체한다.
    private func correctMealPlansOrder() -> [MealPlan] {
        return zip(tempMealPlans, mealTypeOrder).map { (mealPlan, mealType) in
            var _mealPlan = mealPlan
            _mealPlan.set(mealType: mealType)
            return _mealPlan
        }
    }

    private func mealView(of mealPlan: MealPlan) -> some View {
        NavigationLink(value: mealPlan) {
            HStack(spacing: 11.8) {
                mealIcon(of: mealPlan)
                ColoredIngredientsText(mealPlan: mealPlan, type: .cell)
                    .frame(width: 230.responsibleWidth, alignment: .leading)
                Spacer()
                rightIcon
            }
            .padding(
                top: K.mealViewPadding,
                leading: K.mealViewPadding,
                bottom: K.mealViewPadding,
                trailing: K.mealViewTrailingPadding
            )
        }
        .disabled(isEditMode)
        .frame(minHeight: K.mealViewMinHeight)
    }

    private var mealDivider: some View {
        Rectangle()
            .padding(.horizontal, K.dividerPadding )
            .frame(height: K.dividerHeight)
            .foregroundStyle(K.backgroundStrokeNormalColor)
    }
}

// MARK: - Meal View

extension DraggableMealGroupView {
    private func mealIcon(of mealPlan: MealPlan) -> some View {
        Image(mealPlan.mealType.icon)
            .font(.body)
            .foregroundStyle(K.mealIconColor)
    }

    private func ingredientText(of mealPlan: MealPlan) -> some View {
        Text(mealPlan.ingredientsString)
            .customFont(.header5, color: K.testedIngredientTextColor)
    }

    private var rightIcon: some View {
        Image(assetName: isEditMode ? .editDetail : .rightChevronSmall)
    }

    private var chevron: some View {
        Image(systemName: K.chevronRightSFSymbolName)
            .foregroundStyle(K.chevronColor)
    }
}

extension DraggableMealGroupView {
    private enum K {
        static var wholeVStackSpacing: CGFloat { 16 }
        // dateInformation
        static var dayDisplayTextColor: Color { .defaultText.opacity(0.4) }
        static var dateInformationHStackSpacing: CGFloat { 6 }
        // meal
        static var dividerPadding: CGFloat { -30 }
        static var dividerHeight: CGFloat { 1.4 }
        // chevron
        static var chevronRightSFSymbolName: String { "chevron.right" }
        static var chevronColor: Color { .quarternaryText }

        // mealview
        static var mealViewPadding: CGFloat { 18 }
        static var mealViewMinHeight: CGFloat { 64 }
        static var mealViewTrailingPadding: CGFloat { 12 }
        static var mealIconColor: Color { .accentColor2 }
        static var testedIngredientTextColor: Color { .primeText }
        // background
        static var backgroundRectangleRadius: CGFloat { 12 }
        static var backgroundStrokeNormalColor: Color { .listStrokeColor }
        static var backgroundStrokeLineWidth: Double { 2 }
    }
}
