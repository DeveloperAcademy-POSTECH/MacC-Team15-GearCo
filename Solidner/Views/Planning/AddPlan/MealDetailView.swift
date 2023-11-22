//
//  MealDetailView.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import SwiftUI

struct MealDetailView: View {
    private let Texts = TextLiterals.MealDetail.self
    @State private var newIngredient: Ingredient?
    @State private var testedIngredients: [Ingredient] = Ingredient.mockIngredients
    @State private var selectedMealType: MealType?
    @State private var cycleGap: Int
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var showSettingStartDate: Bool = false

    private(set) var isEditMode: Bool = false

    init(startDate: Date = Date()) {
        self._startDate = State(initialValue: startDate)
        let defaultCycleGap = 3
        _cycleGap = State(initialValue: defaultCycleGap)
        _endDate = State(initialValue: Calendar.current.date(byAdding: .day, value: defaultCycleGap - 1, to: startDate)!)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    addIngredients
                    ThickDivider()
                    mealTypeSelectView
                    ThickDivider()
                    mealCycle
                    if isEditMode {
                        ThickDivider()
                        deleteMealPlan
                    }
                }
                .padding()
            }
            addMealPlanButton
                .padding()
        }
    }

    // MARK: - addIngredients

    @ViewBuilder
    private var addIngredients: some View {
        if (isEditMode) {
            // TODO: - 재료 디테일어찌구에.. chip 추가해야.. Title And Hint View를 수정할지, 아니면 새로 만들지가 고민.
            TitleAndHintView(
                title: Texts.ingredientsDetailTitleText,
                //                title: Texts.insertIngredientText,
                hint: Texts.insertIngredientHintText
            )
        } else {
            TitleAndHintView(
                title: Texts.insertIngredientText,
                hint: Texts.insertIngredientHintText
            )
        }
        newIngredientAddView
        // TODO: addedNewIngredient 구현
        //        addedNewIngredient
        otherIngredientAddView
        addedOtherIngredient
    }

    private var addedOtherIngredient: some View {
        ForEach(testedIngredients) { ingredient in
            ingredientView(of: ingredient)
        }
    }

    private var newIngredientAddView: some View {
        TitleAndActionButtonView(
            title: Texts.newIngredientText,
            buttonLabel: Texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                addNewIngredient()
            }
    }

    private var otherIngredientAddView: some View {
        TitleAndActionButtonView(
            title: Texts.testedIngredientText,
            buttonLabel: Texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                addOtherIngredient()
            }
    }

    // TODO: IngredientView Component화 하기
    private func ingredientView(of ingredient: Ingredient) -> some View {
        let colorChip = RoundedRectangle(cornerRadius: 5)
            .frame(width: 16, height: 16)
            .foregroundStyle(ingredient.type.color)

        return HStack(spacing: 10) {
            colorChip
            Text(ingredient.name)
            Spacer()
            Button {
                delete(ingredient: ingredient)
            } label: {
                Text(Texts.deleteText)
            }
        }
        .padding()
        .background {
            Color.gray.clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func delete(ingredient: Ingredient) {
        withAnimation {
            testedIngredients.removeAll { $0 == ingredient }
        }
    }

    // TODO: 올바른 callback 함수 구현 - addNewIngredient
    private func addNewIngredient() {
        print(#function)
    }

    // TODO: 올바른 callback 함수 구현 - addOtherIngredient
    private func addOtherIngredient() {
        print(#function)
    }

    // MARK: - mealType

    @ViewBuilder
    private var mealTypeSelectView: some View {
        TitleAndHintView(
            title: Texts.mealTypeText,
            hint: Texts.mealTypeHintText
        )
        mealTypeButtons
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
        Button {
            mealTypeButtonTapped(mealType)
        } label: {
            Text(mealType.description)
                .bold()
                .padding()
                .foregroundStyle(selectedMealType == mealType ? Color.white : Color.black)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedMealType == mealType ? Color.blue : Color.gray,
                              strokeBorder: selectedMealType == mealType ? .gray : .black,
                              lineWidth: 2)
                )
        }
    }

    private func mealTypeButtonTapped(_ mealType: MealType) {
        print(#function)
        withAnimation {
            selectedMealType = mealType
        }

    }

    // MARK: - mealCycle

    @ViewBuilder
    private var mealCycle: some View {
        TitleAndHintView(
            title: Texts.mealCycleText,
            hint: Texts.mealCycleHintText
        )
        startDateSelectView
        mealPicker
        Divider().padding(.vertical)
        resultCycleText
    }

    private var startDateSelectView: some View {
        HStack {
            TitleAndActionButtonView(
                title: Texts.startDateText,
                buttonLabel: Texts.changeDateText) {
                    showSettingStartDate = true
                }
                .sheet(isPresented: $showSettingStartDate) {
                    StartDateSettingModal(startDate: $startDate)
                        .presentationDetents([.medium])
                }
                .onChange(of: startDate) { newValue in
                    endDate = Calendar.current.date(byAdding: .day, value: cycleGap-1, to: newValue)!
                }
        }
    }

    // TODO: Custom Picker 만들기
    private var mealPicker: some View {
        HStack {
            Text(Texts.gapText)
                .font(.title3).bold()
            Spacer()
                .frame(maxWidth: 100)
                .foregroundColor(.blue)
                .background(Color.red)
                .overlay(Color.gray)
            CycleGapSegmentedPicker(
                Array(1..<5),
                selection: $cycleGap
            ) { item in
                Text(Texts.dateText(item))
                    .font(.callout).bold()
                    .padding(.horizontal, 10)
            }
            .onChange(of: cycleGap) { newValue in
                endDate = Calendar.current.date(byAdding: .day, value: newValue-1, to: startDate)!
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    private var resultCycleText: some View {
        Text(Texts.fromStartDate(startDate)) + Text(endDate.formatted(.yyyyMMdd_dot))
        Text(Texts.gapDetailText(cycleGap))
    }

    // MARK: - addPlanButton

    // TODO: Button 컴포넌트로 교체 -> Big Button
    private var addMealPlanButton: some View {
        Button {
            addMealPlan()
        } label: {
            Text(Texts.addMealPlanButtonText)
                .font(.title3).bold()
                .foregroundStyle(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(uiColor:.systemGray4))
                }
        }
    }

    // TODO: 올바른 callback 함수 구현 - addPlan
    private func addMealPlan() {
        print(#function)
    }

    // MARK: - Delete meal plan
    private var deleteMealPlan: some View {
        TitleAndActionButtonView(
            title: Texts.deleteMealPlanTitleText,
            buttonLabel: Texts.deleteMealPlanButtonText) {
                print(#function)
            }
    }
}
//
//#Preview {
//    MealDetailView()
//}
