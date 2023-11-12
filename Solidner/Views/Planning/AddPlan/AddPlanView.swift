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
    @State private var newIngredient: Ingredient?
//    @State private var testedIngredients: [Ingredient] = []
    @State private var testedIngredients: [Ingredient] = Ingredient.mockIngredients

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
        // TODO: addedNewIngredient 구현
//        addedNewIngredient
        otherIngredientAddView
        addedOtherIngredient
    }

    var addedOtherIngredient: some View {
        ForEach(testedIngredients) { ingredient in
            ingredientView(of: ingredient)
        }
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

    private var newIngredientAddView: some View {
        ingredientAddView(title: Texts.newIngredientText) {
            addNewIngredient()
        }
    }

    private var otherIngredientAddView: some View {
        ingredientAddView(title: Texts.testedIngredientText) {
            addOtherIngredient()
        }
    }

    private func ingredientView(of ingredient: Ingredient) -> some View {
        let colorChip = RoundedRectangle(cornerRadius: 5)
            .frame(width: 16, height: 16)
            .foregroundStyle(Color(uiColor:ingredient.type.color))

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

    // TODO: Custom Picker 만들기
    var mealPicker: some View {
        HStack {
            Text(Texts.gapText)
                .font(.title3).bold()
            Spacer().frame(minWidth: 30)
            Picker(Texts.gapText, selection: $cycleGap) {
                ForEach(1..<5) { day in
                    Text("\(day)일").tag(day)
                }
           }
            .pickerStyle(.segmented)
            .onChange(of: cycleGap) { newValue in
                endDate = Calendar.current.date(byAdding: .day, value: newValue-1, to: startDate)!
            }
        }
        .padding(.vertical)
    }

    @ViewBuilder
    var resultCycleText: some View {
        Text(Texts.fromStartDate(startDate)) + Text(endDate.formatted(.yyyyMMdd_dot))
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

extension AddPlanView {
    struct Ingredient: Identifiable, Equatable {
        static var mockIngredients: [Ingredient] = [
            .init(type: .곡류, name: "쌀"),
            .init(type: .단백질식품군, name: "소고기"),
            .init(type: .녹색채소, name: "청경채")
        ]

        var type: IngredientType
        var name: String
        var id: UUID = UUID()

        enum IngredientType {
            case 곡류, 단백질식품군, 노란채소, 녹색채소, 과일, 유제품, 기타채소, 기타

            var color: UIColor {
                switch self {
                case .곡류:
                    return .lightGray
                case .단백질식품군:
                    return .brown
                case .노란채소:
                    return .yellow
                case .녹색채소:
                    return .green
                case .과일:
                    return .purple
                case .유제품:
                    return .black
                case .기타채소:
                    return .magenta
                case .기타:
                    return .systemIndigo
                }
            }
        }
    }
}
//
//
//#Preview {
//    AddPlanView()
//}
