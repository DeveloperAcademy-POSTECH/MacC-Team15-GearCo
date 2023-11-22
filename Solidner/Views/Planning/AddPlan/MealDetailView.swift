//
//  MealDetailView.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import SwiftUI

struct MealDetailView: View {
    @StateObject private var mealOB = MealOB()
    private let texts = TextLiterals.MealDetail.self
    @State private var showSettingStartDate: Bool = false

    // TODO: 나중에 let으로 바꿀 것
    private(set) var isEditMode: Bool = true

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
}

extension MealDetailView {
    // MARK: - addIngredients
    @ViewBuilder
    private var addIngredients: some View {
        if (isEditMode) {
            // TODO: - 재료 디테일어찌구에.. chip 추가해야.. Title And Hint View를 수정할지, 아니면 새로 만들지가 고민.
            TitleAndHintView(
                title: texts.ingredientsDetailTitleText,
                //                title: Texts.insertIngredientText,
                hint: texts.insertIngredientHintText
            )
        } else {
            TitleAndHintView(
                title: texts.insertIngredientText,
                hint: texts.insertIngredientHintText
            )
        }
        testingIngredientAddView
        // TODO: addedNewIngredient 구현
        addedTestingIngredients
        testedIngredientAddView
        addedTestedIngredients
    }

    private var addedTestingIngredients: some View {
        ForEach(mealOB.testingIngredients) { ingredient in
            ingredientView(of: ingredient, in: .testing)
        }
    }

    private var addedTestedIngredients: some View {
        ForEach(mealOB.testedIngredients) { ingredient in
            ingredientView(of: ingredient, in: .tested)
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
            title: texts.testedIngredientText,
            buttonLabel: texts.addOrEditIngredientText(isEditMode: isEditMode)) {
                addOtherIngredient()
            }
    }

    // TODO: IngredientView Component화 하기

    private func ingredientView(of ingredient: Ingredient, in testType: MealOB.IngredientTestType) -> some View {
        let colorChip = RoundedRectangle(cornerRadius: 5)
            .frame(width: 16, height: 16)
            .foregroundStyle(Color(uiColor:ingredient.type.color))

        return HStack(spacing: 10) {
            colorChip
            Text(ingredient.name)
            Spacer()
            Button {
                withAnimation {
                    mealOB.delete(ingredient: ingredient, in: testType)
                }
            } label: {
                Text(texts.deleteText)
            }
        }
        .padding()
        .background {
            Color.gray.clipShape(RoundedRectangle(cornerRadius: 12))
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
    @ViewBuilder
    private var mealTypeSelectView: some View {
        TitleAndHintView(
            title: texts.mealTypeText,
            hint: texts.mealTypeHintText
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
            mealOB.set(mealType: mealType)
        } label: {
            Text(mealType.description)
                .bold()
                .padding()
                .foregroundStyle(mealOB.mealType == mealType ? Color.white : Color.black)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(mealOB.mealType == mealType ? Color.blue : Color.gray,
                              strokeBorder: mealOB.mealType == mealType ? .gray : .black,
                              lineWidth: 2)
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
                    StartDateSettingModal(planOB: mealOB)
                        .presentationDetents([.medium])
                }
        }
    }

    // TODO: Custom Picker 만들기
    private var mealPicker: some View {
        HStack {
            Text(texts.gapText)
                .font(.title3).bold()
            Spacer()
                .frame(maxWidth: 100)
                .foregroundColor(.blue)
                .background(Color.red)
                .overlay(Color.gray)
            CycleGapSegmentedPicker(
                Array(1..<5),
                selection: $mealOB.cycleGap
            ) { item in
                Text(texts.dateText(item))
                    .font(.callout).bold()
                    .padding(.horizontal, 10)
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    private var resultCycleText: some View {
        Text(texts.fromStartDate(mealOB.startDate)) + Text(mealOB.endDate.formatted(.yyyyMMdd_dot))
        Text(texts.gapDetailText(mealOB.cycleGap))
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

// MARK: - addPlanButton
extension MealDetailView {
    // TODO: Button 컴포넌트로 교체 -> Big Button
    private var addMealPlanButton: some View {
        Button {
            mealOB.addMealPlan()
        } label: {
            Text(texts.addMealPlanButtonText)
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
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView()
    }
}
