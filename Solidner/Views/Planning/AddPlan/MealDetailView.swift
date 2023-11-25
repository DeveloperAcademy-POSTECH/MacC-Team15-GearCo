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
        VStack(alignment: K.VStack.defaultAlignment, spacing: K.VStack.rootSpacing) {
            ScrollView {
                VStack(alignment: .leading, spacing: K.VStack.inRootScrollSpacing) {
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
                .padding(.horizontal, K.defaultHorizontalPadding)
            }
            Group {
                toastMessage
                addMealPlanButton
            }
            .padding(.horizontal, K.defaultHorizontalPadding)
        }
        .withClearBackground(color: .secondBgColor)
    }
}

extension MealDetailView {
    private func VStackInComponent<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: K.VStack.defaultAlignment, spacing: K.VStack.inComponentSpacing, content: item)
    }

    private func VStackInIngredientsComponent<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: K.VStack.defaultAlignment, spacing: K.VStack.ingredientsComponentSpacing, content: item)
    }

    private func VStackInIngredients<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: K.VStack.defaultAlignment, spacing: K.VStack.ingredientsSpacing, content: item)
    }

}

extension MealDetailView {
    // MARK: - ingredientEditOrAdd
    private var ingredientEditOrAdd: some View {
        VStackInComponent {
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
        VStackInIngredientsComponent {
            testingIngredientAddView
            addedTestingIngredients
        }
    }

    private var oldIngredientsView: some View {
        VStackInIngredientsComponent {
            testedIngredientAddView
            addedTestedIngredients
        }
    }

    private var titleAndIngredientsChip: some View {
        let title: some View = {
            Text(texts.viewInEditTitleText)
                .customFont(.header2, color: .defaultText)
        }()
        return VStack(spacing: K.IngredientTitleAndChip.vStackSpacing){
            title
            ColoredIngredientsText(mealPlan: mealOB.mealPlan, type: .chip)
                .padding(K.IngredientTitleAndChip.padding)
                .withRoundedBackground(cornerRadius: K.IngredientTitleAndChip.backgroundCornerRadius, color: .defaultText_wh)
        }
        .padding(K.IngredientTitleAndChip.vstackPadding)
        //        return HStack {
        //            VStack(spacing: 16){
        //                title
        //                ColoredIngredientsText(mealPlan: mealOB.mealPlan, type: .chip)
        //                    .padding(top: 5, leading: 10, bottom: 7, trailing: 10)
        //                    .withRoundedBackground(cornerRadius: 4.87, color: .defaultText_wh)
        //            }
        //            Spacer()
        //        }
        //        .padding(.bottom, -10)
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
        VStackInIngredients {
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
        VStackInComponent {
            TitleAndHintView(
                type: .leading14,
                title: texts.mealTypeText,
                hint: texts.mealTypeHintText
            )
            mealTypeButtons
        }
    }

    private var mealTypeButtons: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
        return LazyVGrid(columns: columns) {
            ForEach(MealType.allCases, id: \.self) { mealType in
                MealTypeButton(mealOB: mealOB, mealType: mealType)
            }
        }
    }
}

// MARK: - mealCycle
extension MealDetailView {
    @ViewBuilder
    private var mealCycle: some View {
        VStackInComponent {
            TitleAndHintView(
                type: .leading14,
                title: texts.mealCycleText,
                hint: texts.mealCycleHintText
            )
            mealCycleContents
        }
    }

    private var mealCycleContents: some View {
        VStack(alignment: K.VStack.defaultAlignment, spacing: .zero) {
            startDateSelectView
                .padding(.bottom, 33)
            mealPicker
                .padding(.bottom, 36)
            Divider()
                .padding(.bottom, 20)
            resultCycleText
                .padding(.bottom, 90-26)
        }
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
    }

    @ViewBuilder
    private var resultCycleText: some View {
        VStack(alignment: K.VStack.defaultAlignment, spacing: K.MealCycle.resultCycleVStackSpacing) {
            Text(texts.fromToDateText(from: mealOB.tempMealPlan.startDate, to: mealOB.tempMealPlan.endDate))
                .customFont(.header5, color: .primeText)
            Text(texts.gapDetailText(mealOB.tempMealPlan.cycleGap.rawValue))
                .customFont(.body1, color: K.MealCycle.resultCycleGapTextColor)
        }

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
    struct MealTypeButton: View {
        @ObservedObject var mealOB: MealOB
        let mealType: MealType
        var isTypeSelected: Bool { mealOB.tempMealPlan.mealType == mealType }

        var body: some View {
            Button {
                mealOB.set(mealType: mealType)
            } label: {
                Text(mealType.description)
                    .customFont(.header6, color: K.textColor(when: isTypeSelected))
                    .frame(maxWidth: .infinity)
                    .frame(height: K.labelFrameHeight)
                    .withRoundedBackground(
                        cornerRadius: K.Background.cornerRadius,
                        fill: K.Background.fill(when: isTypeSelected),
                        strokeBorder: K.Background.strokeBorder,
                        lineWidth: K.Background.lineWidth
                    )
            }
        }
    }
}

extension MealDetailView {
    private enum K {
        static var defaultHorizontalPadding: CGFloat { 20 }
        enum IngredientTitleAndChip {
            static var vStackSpacing: CGFloat { 16 }
            static var padding: EdgeInsets { .init(top: 5, leading: 10, bottom: 7, trailing: 10) }
            static var backgroundCornerRadius: CGFloat { 4.87 }
            static var vstackPadding: EdgeInsets { .init(top: 0, leading: 0, bottom: -10, trailing: 0) }
        }

        enum VStack {
            static var defaultAlignment: HorizontalAlignment { .leading }
            static var rootSpacing: CGFloat { 16 }
            static var inRootScrollSpacing: CGFloat { 26 }
            static var inComponentSpacing: CGFloat { 40 }
            static var ingredientsComponentSpacing: CGFloat { 26 }
            static var ingredientsSpacing: CGFloat { 10 }
        }

        enum MealCycle {
            static var resultCycleGapTextColor: Color { .primeText.opacity(0.4) }
            static var resultCycleVStackSpacing: CGFloat { 10 }
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

extension MealDetailView.MealTypeButton {
    private enum K {
        static func textColor(when condition: Bool) -> Color {
            if(condition) { Color.defaultText_wh }
            else { Color.primeText }
        }
        static var labelFrameHeight: CGFloat { 48 }
        enum Background {
            static var cornerRadius: CGFloat { 12 }
            static func fill(when condition: Bool) -> some ShapeStyle {
                return condition ? Color.accentColor1 : Color.buttonBgColor
            }
            static var strokeBorder: some ShapeStyle { Color.buttonStrokeColor }
            static var lineWidth: Double { 1.5 }
        }
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
    }
}
