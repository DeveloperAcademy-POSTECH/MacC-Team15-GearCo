//
//  AddPlanView.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import SwiftUI

struct AddPlanView: View {
    private let Texts = TextLiterals.AddPlan.self
    let startDate: Date
    @State private var cycleGap: Int
    @State private var endDate: Date

    init(startDate: Date = Date()) {
        self.startDate = startDate
        let defaultCycleGap = 3
        _cycleGap = State(initialValue: defaultCycleGap)
        _endDate = State(initialValue: Calendar.current.date(byAdding: .day, value: defaultCycleGap - 1, to: startDate)!)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    addIngredients
                    divider
                    mealCycle
                }
            }
            Spacer()
            addPlanButton
        }
    }

    var divider: some View {
        Rectangle()
            .foregroundStyle(Color(uiColor: .systemGray5))
            .frame(height: 10)
    }

    @ViewBuilder
    var addIngredients: some View {
        titleAndHintView(
            title: Texts.insertIngredientText,
            hint: Texts.insertIngredientHintText
        )
        newIngredientAddView
        otherIngredientAddView
    }

    func titleAndHintView(title: String, hint: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title).bold()
            Text(hint)
                .font(.body)
                .foregroundStyle(.gray)
        }
        .padding(.vertical)
    }

    var newIngredientAddView: some View {
        ingredientAddView(title: Texts.newIngredientText) {
            addNewIngredient()
        }
    }

    var otherIngredientAddView: some View {
        ingredientAddView(title: Texts.testedIngredientText) {
            addOtherIngredient()
        }
    }

    // TODO: Button 컴포넌트로 교체 하기
    func ingredientAddView(title: String, addAction: @escaping ()->Void) -> some View {
        HStack {
            Text(title)
                .font(.title3).fontWeight(.semibold)
            Spacer()
            Button {
                addAction()
            } label: {
                Text(Texts.addIngredientText)
            }
        }
        .padding(.vertical)
    }

    // TODO: 올바른 callback 함수 구현 - addNewIngredient
    func addNewIngredient() {
        print(#function)
    }

    // TODO: 올바른 callback 함수 구현 - addOtherIngredient
    func addOtherIngredient() {
        print(#function)
    }

    @ViewBuilder
    var mealCycle: some View {
        titleAndHintView(
            title: Texts.mealCycleText,
            hint: Texts.mealCycleHintText
        )
        mealPicker
        Divider().padding(.vertical)
        resultCycleText
    }

    // TODO: Picker 만들기
    var mealPicker: some View {
        HStack {
            Text(Texts.gapText)
                .font(.title3).bold()
        }
        .padding(.vertical)
    }

    @ViewBuilder
    var resultCycleText: some View {
        Text(Texts.fromStartDate(Date())) + Text(endDate.formatted(.yyyyMMdd_dot))
        Text(Texts.gapDetailText(cycleGap))
    }

    // TODO: Button 컴포넌트로 교체
    var addPlanButton: some View {
        Button {
            addPlan()
        } label: {
            Text(Texts.addPlanButtonText)
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
    func addPlan() {
        print(#function)
    }
}

//#Preview {
//    AddPlanView()
//}