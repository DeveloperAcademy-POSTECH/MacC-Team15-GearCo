//
//  MealDetailView.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import SwiftUI

struct MealDetailView: View {
    @EnvironmentObject var user: UserOB
    @StateObject private var mealOB: MealOB
    @State private var showSettingStartDate: Bool = false
    @State private var isDeleteButtonTapped: Bool = false
    
    @State private var showToast: Bool = false
    @State private var toastCounter = 0
    
    @State private var showAddNewIngredientView: Bool = false
    @State private var showAddOldIngredientView: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    private let texts = TextLiterals.MealDetail.self

    let isEditMode: Bool
    
    // meal cell을 눌러서 들어온 경우 - 끼니 편집
    init(mealPlan: MealPlan, cycleGap: CycleGaps, mealPlansOB: MealPlansOB) {
        self._mealOB = StateObject(wrappedValue: MealOB(mealPlan: mealPlan, cycleGap: cycleGap, mealPlansOB: mealPlansOB))
        self.isEditMode = true
    }
    
    // from Daily Plan List View - 끼니 추가
    init(startDate: Date, cycleGap: CycleGaps, mealPlansOB: MealPlansOB) {
        self._mealOB = StateObject(wrappedValue: MealOB(startDate: startDate, cycleGap: cycleGap, mealPlansOB: mealPlansOB))
        self.isEditMode = false
    }
    
    // from Plan Group Detail View - 끼니 추가
    init(startDate: Date, endDate: Date, mealPlansOB: MealPlansOB) {
        let cycleGap = CycleGaps(rawValue:Date.componentsBetweenDates(from: startDate, to: endDate).day! + 1) ?? .three
        self._mealOB = StateObject(wrappedValue: MealOB(startDate: startDate, cycleGap: cycleGap, mealPlansOB: mealPlansOB))
        self.isEditMode = false
    }
    
    var body: some View {
        RootVStack {
            viewHeader
            viewBody
                .defaultBottomPadding()
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    @ViewBuilder
    private var viewHeader: some View {
        let isSingle = mealOB.cycleGap == .one
        BackButtonAndTitleHeader(
            title: texts.viewHeaderTitleText(
                from: mealOB.startDate,
                to: mealOB.endDate,
                isSingle: isSingle
            )
        )
    }
    
    private var viewBody: some View {
        VStack(alignment: .leading, spacing: K.VStack.rootSpacing) {
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
                .defaultViewBodyTopPadding()
                .defaultHorizontalPadding()
            }
            Group {
                if showToast { toastMessage }
                addMealPlanButton
            }
            .defaultHorizontalPadding()
        }
    }
}

extension MealDetailView {
    private func VStackInComponent<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: .leading, spacing: K.VStack.inComponentSpacing, content: item)
    }

    private func VStackInIngredientsComponent<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: .leading, spacing: K.VStack.ingredientsComponentSpacing, content: item)
    }

    private func VStackInIngredients<Content: View>(@ViewBuilder item:@escaping () -> Content) -> some View {
        return VStack(alignment: .leading, spacing: K.VStack.ingredientsSpacing, content: item)
    }
}

extension MealDetailView {
    // MARK: - ingredientEditOrAdd
    private var ingredientEditOrAdd: some View {
        VStackInComponent {
            titleHeader
            newIngredientsView
            oldIngredientsView
        }
    }

    @ViewBuilder
    private var titleHeader: some View {
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

    @ViewBuilder
    private var titleAndIngredientsChip: some View {
        let title: some View = {
            Text(texts.viewInEditTitleText)
                .customFont(.header2, color: .defaultText)
        }()
        if mealOB.mealPlan != nil {
            VStack(alignment: .leading, spacing: K.IngredientTitleAndChip.vStackSpacing){
                title
                ColoredIngredientsText(
                    newIngredients: mealOB.newIngredients,
                    oldIngredients: mealOB.oldIngredients,
                    type: .chip
                )
                    .padding(K.IngredientTitleAndChip.padding)
                    .withRoundedBackground(cornerRadius: K.IngredientTitleAndChip.backgroundCornerRadius, color: .defaultText_wh)
            }
            .padding(K.IngredientTitleAndChip.vstackPadding)
        } else {
            EmptyView()
        }
    }
    
    // TODO: - 추후 이상 반응이 추가된다면, .new 말고 이상반응 뱃지 달아야함
    private var addedTestingIngredients: some View {
        addedIngredientsView(
            of: mealOB.newIngredients,
            type: .new
        )
    }

    private var addedTestedIngredients: some View {
        addedIngredientsView(
            of: mealOB.oldIngredients,
            type: .old
        )
    }
    
    private func addedIngredientsView(of ingredients: [Ingredient], type: MealOB.IngredientTestType) -> some View {
        VStackInIngredients {
            ForEach(ingredients) { ingredient in
                let viewType: AddedIngredientView.AddedIngredientViewType = {
                    let isMisMatched = mealOB.mismatches.contains(where: { $0.id == ingredient.id })
                    let isNew = type == .new
                    if !isEditMode { // Edit 모드가 아닐 때 - 삭제
                        return .deletable
                    } else if isMisMatched && isNew {
                        return .mismatchAndNew
                    } else if type == .new { // Edit 모드인데 새로운 재료일 때
                        return .new
                    } else if isMisMatched {
                        return .mismatch
                    } else if let babyMonth = user.dateAfterBirth.month, babyMonth < ingredient.ableMonth { // able month > 현재 생후 달
                        return .age
                    } else {
                        return .none
                    }
                }()
                
                AddedIngredientView(
                    type: viewType,
                    ingredient: ingredient
                ) {
                    // delete action
                    mealOB.delete(ingredient: ingredient, in: type)
                }
            }
        }
    }

    private var testingIngredientAddView: some View {
        TitleAndActionButtonView(
            title: texts.newIngredientText,
            buttonLabel: texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                showAddNewIngredientView = true
            }.navigationDestination(isPresented: $showAddNewIngredientView) {
                AddTestIngredientsView(.new)
                    .environmentObject(mealOB)
            }
    }

    private var testedIngredientAddView: some View {
        TitleAndActionButtonView(
            title: texts.oldIngredientText,
            buttonLabel: texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                showAddOldIngredientView = true
            }.navigationDestination(isPresented: $showAddOldIngredientView) {
                AddTestIngredientsView(.old)
                    .environmentObject(mealOB)
            }
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
                mealTypeButton(mealType: mealType)
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

    // TODO: - 매직넘버 지우기
//    #warning("매직 넘버 지우기")
    private var mealCycleContents: some View {
        VStack(alignment: .leading, spacing: .zero) {
            startDateSelectView
                .padding(.bottom, 32)
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
                }.sheet(isPresented: $showSettingStartDate) {
                    StartDateSettingModal(mealOB: mealOB)
                        .presentationDetents([.height(475)])
                        .modify { view in
                            if #available(iOS 16.4, *) {
                                view.presentationCornerRadius(25)
                            }
                        }
                }
        }
    }

    private var mealPicker: some View {
        SolidnerSegmentedPicker(
            label: texts.gapText,
            items: CycleGaps.allCases,
            selection: $mealOB.cycleGap
        )
    }

    @ViewBuilder
    private var resultCycleText: some View {
        VStack(alignment: .leading, spacing: K.MealCycle.resultCycleVStackSpacing) {
            Text(texts.fromToDateText(from: mealOB.startDate, to: mealOB.endDate))
                .customFont(.header5, color: .primeText)
            Text(texts.gapDetailText(mealOB.cycleGap.rawValue))
                .customFont(.body1, color: K.MealCycle.resultCycleGapTextColor)
        }

    }
}

// TODO: - 매직 스트링 지우기
//#warning("매직 스트링 지우기")
// MARK: - Delete meal plan
extension MealDetailView {
    private var deleteMealPlan: some View {
        TitleAndActionButtonView(
            title: texts.deleteMealPlanTitleText,
            buttonLabel: texts.deleteMealPlanButtonText) {
                isDeleteButtonTapped = true
            }
            .alert("일정 삭제", isPresented: $isDeleteButtonTapped) {
                Button("삭제", role: .destructive) {
                    mealOB.deleteMealPlan(user: user)
                    dismiss()
                }
            } message: {
                Text("해당 끼니 일정을 삭제할까요?")
            }
            .padding(.bottom, 100)
    }
}

// MARK: - toast Message
// TODO: - taost Message는 나타난지 3초 이후에 사라짐.
extension MealDetailView {
    private var toastMessage: some View {
        ToastMessage(type: .savePlan)
    }
}

// MARK: - addPlanButton
extension MealDetailView {
    private var addMealPlanButton: some View {
        ButtonComponents(
            .big,
            title: texts.mealPlanBottomButtonText(isEditMode: isEditMode),
            disabledCondition: mealOB.isAddButtonDisabled && !isEditMode
        ) {
            if isEditMode {
                addMealPlanButtonTapped()
            }
            else {
                mealOB.addMealPlan(user: user)
                dismiss()
            }
        }
    }
    
    private func addMealPlanButtonTapped() {
        showToast = true
        toastCounter += 1
        let currentCounter = toastCounter
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if currentCounter == toastCounter {
                showToast = false
            }
        }
        mealOB.changeMealPlan(user: user)
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
    
    private func mealTypeButton(mealType: MealType) -> some View {
        let isTypeSelected = mealOB.mealType == mealType
        
        return Button {
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

extension MealDetailView {
    private enum K {
        enum IngredientTitleAndChip {
            static var vStackSpacing: CGFloat { 16 }
            static var padding: EdgeInsets { .init(top: 5, leading: 10, bottom: 7, trailing: 10) }
            static var backgroundCornerRadius: CGFloat { 4.87 }
            static var vstackPadding: EdgeInsets { .init(top: 0, leading: 0, bottom: -10, trailing: 0) }
        }

        enum VStack {
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

extension MealDetailView.TitleAndActionButtonView {
    private enum K {
        enum TitleAndActionButton {
            static var buttonTextColor: Color { .defaultText.opacity(0.8) }
        }
    }
}

//struct MealDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MealDetailView(mealPlan: MealPlan.mockMealsOne.first!, cycleGap: .two)
//    }
//}
