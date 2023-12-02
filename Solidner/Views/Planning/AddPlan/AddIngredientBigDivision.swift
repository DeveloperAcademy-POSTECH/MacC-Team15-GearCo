//
//  AddIngredientBigDivision.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/23.
//

import SwiftUI

enum DivisionCase: String {
    case 이상반응재료 = "이상 반응 재료"
    case 먹을수있는재료 = "먹을 수 있는 재료"
    case 권장하지않는재료 = "권장하지 않는 재료"
    case 자주사용한재료 = "자주 사용한 재료"
    case 검색
}

struct IngredientsBigDivision: View {
    // MARK: Numbers
    private let titleTopSpace: CGFloat = 16
    private let viewHorizontalPadding: CGFloat = 20
    private let titleBottomSpace: CGFloat = 24
    private let rowBetweenSpace: CGFloat = 30
    private let divisionBottomSpace: CGFloat = 1
    
    private let foldSectionTitleVerticalPadding: CGFloat = 24
    private let foldSectionLightDividerBottomSpace: CGFloat = 20
    private let divisionTitleBottomSpace: CGFloat = 14
    private let divisionSubTitleBottomSpace: CGFloat = 4
    
    private let divierTopSpaceWhenNotFolded: CGFloat = 10
    
    // MARK: let properties
    let ingredientData = IngredientData.shared.ingredients
    private let Texts = TextLiterals.AddIngredientsView.self
    let divisionCase: DivisionCase
    
    var explainText: String {
        switch divisionCase {
        case .먹을수있는재료:
            return Texts.먹을수있는재료Explain
        case .권장하지않는재료:
            return Texts.권장하지않는재료Explain
        default:
            return ""
        }
    }
    
    // MARK: Property Wrapper, init, etc
    @EnvironmentObject var user: UserOB
    @Binding var selectedIngredients: [Int]
    @Binding var ingredientUseCount: [Int: Int]
    @State private var foldStates: [IngredientType: Bool]
    
    @State private var searchText = ""
    @FocusState private var isSearchFieldFocused: Bool
    
    let viewType: MealOB.IngredientTestType
    let initialSelectedIngredients: [Int]   // selectedIngredients 복사. 테스트 재료 추가 화면에서 정상적으로 보일 수 있게.
    let scrollID: ScrollID
    
    init(case divisionCase: DivisionCase, ingredients selectedIngredients: Binding<[Int]>,
         initSelected initialSelectedIngredients: [Int], viewType: MealOB.IngredientTestType,
         ingredientUseCount: Binding<[Int: Int]>, scrollID: ScrollID) {
        self.divisionCase = divisionCase
        self.viewType = viewType
        self._ingredientUseCount = ingredientUseCount
        
        self._selectedIngredients = selectedIngredients
        self.initialSelectedIngredients = initialSelectedIngredients
        self.scrollID = scrollID
        
        var states: [IngredientType: Bool] = [:]
        for type in IngredientType.allCases {
            states[type] = false
        }
        self._foldStates = State(initialValue: states)
    }
    
    private func toggleFoldState(foldStateList: inout [IngredientType: Bool], type: IngredientType) {
        foldStateList[type]?.toggle()
    }
    
    private func filterAndSortIngredients(by searchTerm: String, from values: [Ingredient]) -> [Ingredient] {
        if searchTerm.isEmpty {
            return values.sorted { $0.name < $1.name }
        }
        // 재료 name으로 filtering 및 sorting
        return values.filter { $0.name.localizedCaseInsensitiveContains(searchTerm) }
                     .sorted { $0.name < $1.name }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch divisionCase {
            case .이상반응재료:
                이상반응재료Division()
            case .먹을수있는재료:
                먹을수있는권장하지않는Division()
            case .권장하지않는재료:
                먹을수있는권장하지않는Division()
            case .자주사용한재료:
                자주사용한재료Division()
            case .검색:
                검색화면()
            }
        }.padding(.horizontal, viewHorizontalPadding)
    }
}

// MARK: Division View
extension IngredientsBigDivision {
    private func 검색화면() -> some View {
        var filteredIngredients: [Ingredient] {
            let ingredients = ingredientData.values.filter { ingredient in
                (viewType == .new && ingredientUseCount[ingredient.id, default: 0] == 0) ||
                (viewType == .old && ingredientUseCount[ingredient.id, default: 0] != 0)
            }
            return filterAndSortIngredients(by: searchText, from: ingredients)
        }

        return VStack(spacing: 0) {
            TextFieldComponents().shortTextfield(placeHolder: "", value: $searchText, isFocused: $isSearchFieldFocused)
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(Color.buttonStrokeColor, lineWidth: 1) }
            
                Divider()
                    .padding(.top, foldSectionLightDividerBottomSpace)
                ForEach(filteredIngredients, id: \.self) { ingredient in
                    ingredientSelectRow(case: divisionCase, ingredient: ingredient, selected: $selectedIngredients, viewType: viewType)
                        .padding(.vertical, 15)
            }
        }
    }
    
    private func 먹을수있는권장하지않는Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            TitleAndHintView(title: divisionCase.rawValue, hint: explainText)
            Spacer().frame(height: divisionSubTitleBottomSpace)
            
            ForEach(Array(IngredientType.allCases.enumerated()), id: \.element) { index, type in
                HStack(spacing: 0) {
                    Text(type.description)
                        .font(.system(size: 19, weight: .semibold))
                        .padding(.trailing, 2)
                    if divisionCase == .권장하지않는재료 {
                        Image(systemName: "xmark.shield.fill")
                            .foregroundStyle(Color.ageColor)
                            .scaledToFit()
                            .frame(width: 23)
                    }
                    Spacer()
                    Image(systemName: foldStates[type]! ? "chevron.up" : "chevron.down")
                        .resizable()
                        .bold()
                        .frame(width: 18, height: 10)
                }.padding(.vertical, foldSectionTitleVerticalPadding)
                .contentShape(Rectangle())
                .foregroundColor(.black)
                .toggleStyle(.automatic)
                .onTapGesture {
                    withAnimation(.spring()) {
                        toggleFoldState(foldStateList: &foldStates, type: type)
                    }
                }.id(divisionCase == .먹을수있는재료 ? scrollID.namespaces1[index] : scrollID.namespaces2[index])
                
                if foldStates[type]! {
                    Divider()
                        .padding(.bottom, foldSectionLightDividerBottomSpace)
                    Group {
                        ForEach(ingredientData.keys.sorted(), id: \.self) { key in
                            // 개월 수 필터링(month), type 필터링 (type foreach 내부임)
                            let data = ingredientData[key]!
                            let month = user.dateAfterBirth.month!
                            // 재료가 보이려면 -> new&사용횟수0 / old&사용횟수1이상 / 현재선택된재료
//                            let isIngredientAppear: Bool = (viewType == .new && ingredientUseCount[data.id, default: 0] == 0) || (viewType == .old && ingredientUseCount[data.id, default: 0] != 0) || initialSelectedIngredients.contains { $0 == data.id }
                            
//                            if isIngredientAppear {
                                if divisionCase == .먹을수있는재료 && data.type == type && data.ableMonth <= month {
                                    ingredientSelectRow(case: divisionCase, ingredient: data,
                                                        selected: $selectedIngredients, viewType: viewType).padding(.vertical, 15)
                                } else if divisionCase == .권장하지않는재료 && data.type == type && data.ableMonth > month {
                                    ingredientSelectRow(case: divisionCase, ingredient: data,
                                                        selected: $selectedIngredients, viewType: viewType).padding(.vertical, 15)
                                }
//                            }
                        }
                    }.transition(.push(from: foldStates[type]! ? .bottom : .top))
                }
                
                ThickDivider().if(foldStates[type]!) { view in
                    view.padding(.top, divierTopSpaceWhenNotFolded)
                }
            }
        }
    }
    
    private func 자주사용한재료Division() -> some View {
        // value 기준으로 내림차순 정렬 후 상위 5개 요소 가져오기
        let sortedByValue = ingredientUseCount.sorted { $0.value > $1.value }
        // 상위 5개 요소 추출 (key, value) 형태의 tuple로.
        let topFive = sortedByValue.prefix(5)
        
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text(divisionCase.rawValue)
                .headerFont2()
                .foregroundColor(.defaultText)
            HStack{Spacer()}    // to align left
            Spacer().frame(height: titleBottomSpace)
            ForEach(topFive.indices, id: \.self) { i in
                let id = topFive[i].key
                let ingredient = ingredientData[id]!
                
                ingredientSelectRow(case: divisionCase, ingredient: ingredient,selected: $selectedIngredients, viewType: viewType)
                    .padding(.vertical, 15)
            }
        }
    }
    
    private func 이상반응재료Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text(divisionCase.rawValue)
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: titleBottomSpace)
            HStack{Spacer()}
            // TODO: 실제 데이터로 변경 및 필터링
//            ForEach(ingredientData.keys.sorted(), id: \.self) { key in
//                let data = ingredientData[key]!
//                ingredientSelectRow(divisionCase: divisionCase, ingredient: data, selectedIngredientPair: $selectedIngredients).padding(.vertical, 15)
//            }
        }
    }
}

// MARK: 재료 하나하나의 Row (ingredientSelectRow)
extension IngredientsBigDivision {
    struct ingredientSelectRow: View {
        let dateTextHorizontalPadding: CGFloat = 5
        let dateTextVerticalPadding: CGFloat = 2.5
        let dateBackgroundRadius: CGFloat = 3.8
        let ingredientNameRightSpace: CGFloat = 6
        
        let ingredientData = IngredientData.shared.ingredients
        let divisionCase: DivisionCase
        let ingredient: Ingredient
        
        @EnvironmentObject var mealOB: MealOB
        @Binding var selectedIngredients: [Int]
        let viewType: MealOB.IngredientTestType
        
        var buttonDisableCondition: Bool {
            if selectedIngredients.contains(ingredient.id) {
                return false
            } else if viewType == .old || selectedIngredients.count < 2 {
                return false
            }
            return true
        }
        
        @State private var isClicked: Bool

        init(case divisionCase: DivisionCase, ingredient: Ingredient,
             selected selectedIngredients: Binding<[Int]>, viewType: MealOB.IngredientTestType) {
            self.divisionCase = divisionCase
            self.ingredient = ingredient
            self._selectedIngredients = selectedIngredients
            self._isClicked = State(initialValue: selectedIngredients.wrappedValue.contains(ingredient.id))
            self.viewType = viewType
        }

        var isNotRecommended: Bool {
            // 선택된 재료와 궁합이 맞지 않으면
            for id in selectedIngredients {
                if let misIngredients = ingredientData[id]?.misMatches {
                    for misIngredient in misIngredients {
                        if ingredient.id == misIngredient.id {
                            return true
                        }
                    }
                }
            }
            // mealOB의 반대 재료 (.new 일때 사용한 재료 / .old일때 새 재료)와 궁합이 맞지 않으면
            for idResource in (viewType == .new ? mealOB.oldIngredients : mealOB.newIngredients) {
                let id = idResource.id
                if let misIngredients = ingredientData[id]?.misMatches {
                    for misIngredient in misIngredients {
                        if ingredient.id == misIngredient.id {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        private func addIngredient(ingredient: Ingredient) {
            if selectedIngredients.contains(ingredient.id) {
                selectedIngredients.removeAll{$0 == ingredient.id}
            } else if viewType == .old || selectedIngredients.count < 2 {
                selectedIngredients.append(ingredient.id)
            }
        }
        
        var body: some View {
            HStack(spacing: 0) {
                Text(ingredient.name)
                    .headerFont4()
                Spacer().frame(width: ingredientNameRightSpace)
                switch divisionCase {
                case .이상반응재료:
                    // TODO: 이상반응 시 날짜 확인
                    EmptyView()
//                    Text("00/00")
//                        .tagFont()
//                        .foregroundColor(.defaultText_wh)
//                        .symmetricBackground(HPad: dateTextHorizontalPadding,
//                                             VPad: dateTextVerticalPadding,
//                                             color: .accentColor1,
//                                             radius: dateBackgroundRadius)
                case .자주사용한재료:
                    EmptyView()
                case .먹을수있는재료:
                    EmptyView()
                case .권장하지않는재료:
                    Text("\(ingredient.ableMonth)개월 +")
                        .tagFont()
                        .foregroundColor(.defaultText_wh)
                        .symmetricBackground(HPad: dateTextHorizontalPadding,
                                             VPad: dateTextVerticalPadding,
                                             color: .ageColor,
                                             radius: dateBackgroundRadius)
                case .검색:
                    EmptyView()
                }   // end of switch
                
                Spacer().frame(width: ingredientNameRightSpace)
                if isNotRecommended {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(Color.accentColor1)
                        .scaledToFit()
                        .frame(width: 20)
                }
                
                Spacer()
                
                ButtonComponents(.clickableTiny, disabledCondition: buttonDisableCondition, isClicked: isClicked) {
                    addIngredient(ingredient: ingredient)
                }
            }
        }
    }
}
