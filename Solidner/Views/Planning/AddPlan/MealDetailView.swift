//
//  MealDetailView.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject private var mealOB = MealOB(mealPlan: MealPlan.mockMealsOne.first!)
    private let texts = TextLiterals.MealDetail.self
    @State private var showSettingStartDate: Bool = false
    @State private var isSaveButtonTapped: Bool = false

    // TODO: 나중에 let으로 바꿀 것
    private(set) var isEditMode: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    ingredientEditOrAdd
                    ThickDivider()
                    mealTypeSelectView
                    ThickDivider()
                    mealCycle
                    if isEditMode {
                        ThickDivider()
                        deleteMealPlan
                    }
                }
                .padding(.horizontal, 20)
            }
            Group {
                toastMessage
                addMealPlanButton
            }
            .padding(.horizontal, 20)
        }
        .withClearBackground(color: .secondBgColor)
    }
}

extension MealDetailView {
    // MARK: - ingredientEditOrAdd
    private var ingredientEditOrAdd: some View {
        VStack(spacing: 40) {
            title
            newIngredientsView
            oldIngredientsView
        }
    }

    @ViewBuilder
    private var title: some View {
        if (isEditMode) {
            titleAndIngredientsChip
        } else {
            TitleAndHintView(
                title: texts.viewInAddTitleText,
                hint: texts.viewInAddTitleHintText
            )
        }
    }

    private var newIngredientsView: some View {
        VStack(spacing: 26) {
            testingIngredientAddView
            addedTestingIngredients
        }
    }

    private var oldIngredientsView: some View {
        VStack(spacing: 26) {
            testedIngredientAddView
            addedTestedIngredients
        }
    }

    private var titleAndIngredientsChip: some View {
        let title: some View = {
            Text(texts.viewInEditTitleText)
                .customFont(.header2, color: .defaultText)
        }()
        return HStack {
            VStack(spacing: 16){
                title
                ColoredIngredientsText(mealPlan: mealOB.mealPlan, type: .chip)
                    .padding(top: 5, leading: 10, bottom: 7, trailing: 10)
                    .withRoundedBackground(cornerRadius: 4.87, color: .defaultText_wh)
            }
            Spacer()
        }
        .padding(.bottom, -10)
    }

    private var addedTestingIngredients: some View {
        addedIngredientsView(of: mealOB.tempMealPlan.newIngredients)
//        VStack(spacing: 10) {
//            ForEach(mealOB.tempMealPlan.newIngredients) { ingredient in
//                AddedIngredientView(
//                    type: isEditMode ? .new : .deletable,
//                    ingredient: ingredient
//                )
//            }
//        }
    }

    private var addedTestedIngredients: some View {
        addedIngredientsView(of: mealOB.tempMealPlan.oldIngredients)
    }

    // TODO: - type 어떻게 바꿀지 고민...

    private func addedIngredientsView(of ingredients: [Ingredient]) -> some View {
        VStack(spacing: 10) {
            ForEach(ingredients) { ingredient in
                AddedIngredientView(
                    type: .deletable,
                    ingredient: ingredient
                )
            }
        }
    }

    private var testingIngredientAddView: some View {
        TitleAndActionButtonView(
            title: texts.newIngredientText,
            buttonLabel: texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                addNewIngredient()
            }
    }

    private var testedIngredientAddView: some View {
        TitleAndActionButtonView(
            title: texts.oldIngredientText,
            buttonLabel: texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                addOtherIngredient()
            }
    }

    // TODO: 올바른 callback 함수 구현 - addNewIngredient
    //       -> 재료 추가 화면 띄우기
    private func addNewIngredient() {
        print(#function)
    }

    // TODO: 올바른 callback 함수 구현 - addOtherIngredient
    //       -> 재료 추가 화면 띄우기
    private func addOtherIngredient() {
        print(#function)
    }
}

// MARK: - mealType
extension MealDetailView {
    private var mealTypeSelectView: some View {
        VStack(spacing: 40) {
            HStack {
                TitleAndHintView(
                    title: texts.mealTypeText,
                    hint: texts.mealTypeHintText
                )
            }

            .frame(maxWidth: .infinity)
            mealTypeButtons
        }
    }

    private var mealTypeButtons: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        return LazyVGrid(columns: columns) {
            ForEach(MealType.allCases, id: \.self) { mealType in
                mealTypeButton(of: mealType)
            }
        }
    }

    private func mealTypeButton(of mealType: MealType) -> some View {
        let isTypeSelected = mealOB.tempMealPlan.mealType == mealType
        return Button {
            mealOB.set(mealType: mealType)
        } label: {
            Text(mealType.description)
                .customFont(.header6)
                .foregroundStyle(isTypeSelected ? Color.defaultText_wh : Color.primeText)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isTypeSelected ? Color.accentColor1 : Color.buttonBgColor,
                              strokeBorder: Color.buttonStrokeColor,
                              lineWidth: 1.5)
                )
        }
    }
}

// MARK: - mealCycle
extension MealDetailView {
    @ViewBuilder
    private var mealCycle: some View {
        TitleAndHintView(
            title: texts.mealCycleText,
            hint: texts.mealCycleHintText
        )
        startDateSelectView
        mealPicker
        Divider().padding(.vertical)
        resultCycleText
    }

    private var startDateSelectView: some View {
        HStack {
            TitleAndActionButtonView(
                title: texts.startDateText,
                buttonLabel: texts.changeDateText) {
                    showSettingStartDate = true
                }
                .sheet(isPresented: $showSettingStartDate) {
                    StartDateSettingModal(mealOB: mealOB)
                        .presentationDetents([.medium])
                }
        }
    }

    // TODO: Custom Picker 만들기
    private var mealPicker: some View {
        SolidnerSegmentedPicker(
            label: texts.gapText,
            items: CycleGaps.allCases,
            selection: $mealOB.cycleGap
        )
        .padding(.vertical)
    }

    @ViewBuilder
    private var resultCycleText: some View {
        Text(texts.fromToDateText(from: mealOB.tempMealPlan.startDate, to: mealOB.tempMealPlan.endDate))
            .customFont(.header5, color: .primeText)
        Text(texts.gapDetailText(mealOB.tempMealPlan.cycleGap.rawValue))
            .customFont(.body1, color: K.MealCycle.resultCycleGapTextColor)
    }
}

// MARK: - Delete meal plan
extension MealDetailView {
    private var deleteMealPlan: some View {
        TitleAndActionButtonView(
            title: texts.deleteMealPlanTitleText,
            buttonLabel: texts.deleteMealPlanButtonText) {
                print(#function)
            }
    }
}

// MARK: - toast Message
extension MealDetailView {
    private var toastMessage: some View {
        HStack(spacing: K.ToastMessage.hStackSpacing) {
            Image(assetName: .check)
            Text(texts.editCompleteText)
                .customFont(.toast, color: .tertinaryText)
            Spacer()
        }
        .padding(.leading, K.ToastMessage.hStackPaddingLeading)
        .frame(height: K.ToastMessage.hStackFrameHeight)
        .background(
            RoundedRectangle(cornerRadius: K.ToastMessage.backgroundCornerRadius)
                .fill(
                    Color.defaultText_wh,
                    strokeBorder: Color.listStrokeColor,
                    lineWidth: K.ToastMessage.backgroundLineWidth
                )
        )

    }
}
// MARK: - addPlanButton
extension MealDetailView {
    private var addMealPlanButton: some View {
        ButtonComponents(.big, title: texts.mealPlanBottomButtonText(isEditMode: isEditMode)) {
            mealOB.addMealPlan()
        }
    }
}

extension MealDetailView {
    struct TitleAndActionButtonView: View {
        let title: String
        let buttonLabel: String
        let buttonAction: () -> Void

        init(
            title: String,
            buttonLabel: String,
            buttonAction: @escaping () -> Void = { }
        ) {
            self.title = title
            self.buttonLabel = buttonLabel
            self.buttonAction = buttonAction
        }

        var body: some View {
            HStack {
                Text(title)
                    .customFont(.header4, color: K.TitleAndActionButton.buttonTextColor)
                Spacer()
                ButtonComponents(.tiny, title: buttonLabel) {
                    buttonAction()
                }
            }
        }
    }
}

extension MealDetailView {
    private enum K {
        enum MealCycle {
            static var resultCycleGapTextColor: Color { .primeText.opacity(0.4) }
        }
        enum ToastMessage {
            static var hStackSpacing: CGFloat { 4.27 }
            static var hStackFrameHeight: CGFloat { 48 }
            static var hStackPaddingLeading: CGFloat { 12.25 }
            static var backgroundCornerRadius: CGFloat { 12 }
            static var backgroundLineWidth: CGFloat { 1 }
        }

    }
}

extension MealDetailView.TitleAndActionButtonView {
    private enum K {
        enum TitleAndActionButton {
            static var buttonTextColor: Color { .defaultText.opacity(0.8) }
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
    }
}
