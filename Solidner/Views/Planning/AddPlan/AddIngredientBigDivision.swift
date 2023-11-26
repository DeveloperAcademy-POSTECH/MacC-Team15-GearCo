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
    @Binding var selectedIngredientPair: [Int]
    @State private var foldStates: [IngredientType: Bool]
    
    init(divisionCase: DivisionCase, selectedIngredientPair: Binding<[Int]>) {
        self.divisionCase = divisionCase
        _selectedIngredientPair = selectedIngredientPair

        var states: [IngredientType: Bool] = [:]
        for type in IngredientType.allCases {
            states[type] = false
        }
        _foldStates = State(initialValue: states)
    }
    
    private func addIngredient(ingredient: Ingredient) {
        if selectedIngredientPair.contains(ingredient.id) {
            selectedIngredientPair.removeAll{$0 == ingredient.id}
        } else if selectedIngredientPair.count < 2 {
            selectedIngredientPair.append(ingredient.id)
        }
    }
    
    private func toggleFoldState(foldStateList: inout [IngredientType: Bool], type: IngredientType) {
        foldStateList[type]?.toggle()
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
            }
        }.padding(.horizontal, viewHorizontalPadding)
    }
    
    private func 먹을수있는권장하지않는Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            TitleAndHintView(title: divisionCase.rawValue, hint: explainText)
            Spacer().frame(height: divisionSubTitleBottomSpace)
            
            ForEach(IngredientType.allCases, id: \.self) { type in
                HStack(spacing: 0) {
                    Button {
                        withAnimation(.spring()) {
                            toggleFoldState(foldStateList: &foldStates, type: type)
                        }
                    } label: {
                        Text(type.description)
                            .font(.system(size: 19, weight: .semibold))
                            .padding(.trailing, 6)
                        Spacer()
                        Image(systemName: foldStates[type]! ? "chevron.up" : "chevron.down")
                            .resizable()
                            .bold()
                            .frame(width: 18, height: 10)
                    }.foregroundColor(.black)
                        .toggleStyle(.automatic)
                }.buttonStyle(PlainButtonStyle())   // 깜빡임 제거
                .padding(.vertical, foldSectionTitleVerticalPadding)
                
                if foldStates[type]! {
                    Divider()
                        .padding(.bottom, foldSectionLightDividerBottomSpace)
                    Group {
                        ForEach(ingredientData.keys.sorted(), id: \.self) { key in
                            // 개월 수 필터링(month), type 필터링 (type foreach 내부임)
                            let data = ingredientData[key]!
                            let month = user.dateAfterBirth.month!
                            if divisionCase == .먹을수있는재료 && data.type == type && data.ableMonth <= month {
                                ingredientSelectRow(divisionCase: divisionCase, ingredient: data)
                                    .padding(.vertical, 15)
                            } else if divisionCase == .권장하지않는재료 && data.type == type && data.ableMonth > month {
                                ingredientSelectRow(divisionCase: divisionCase, ingredient: data)
                                    .padding(.vertical, 15)
                            }
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
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text(divisionCase.rawValue)
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: titleBottomSpace)
            // TODO: 실제 데이터로 변경
//            ForEach(Range<Int>(1...4)) { i in
//                ingredientSelectRow(divisionCase: .자주사용한재료)
//                if(i != 4) {
//                    Spacer().frame(height: rowBetweenSpace)
//                } else {
//                    Spacer().frame(height: divisionBottomSpace)
//                }
//            }
        }
    }
    
    private func 이상반응재료Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text(divisionCase.rawValue)
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: titleBottomSpace)
            // TODO: 실제 데이터로 변경
//            ForEach(Range<Int>(1...4)) { i in
//                ingredientSelectRow(divisionCase: .이상반응재료)
//                if(i != 4) {
//                    Spacer().frame(height: rowBetweenSpace)
//                } else {
//                    Spacer().frame(height: divisionBottomSpace)
//                }
//            }
        }
    }
    
    func ingredientSelectRow(divisionCase: DivisionCase, ingredient: Ingredient) -> some View {
        let dateTextHorizontalPadding: CGFloat = 5
        let dateTextVerticalPadding: CGFloat = 2.5
        let dateBackgroundRadius: CGFloat = 3.8
        
        let ingredientNameRightSpace: CGFloat = 6
        
        var buttonDisableCondition: Bool {
            if selectedIngredientPair.contains(ingredient.id) {
                return false
            } else if selectedIngredientPair.count < 2 {
                return false
            }
            return true
        }
        
        var isClicked: Bool = selectedIngredientPair.contains(ingredient.id)
        
        // TODO: 텍스트 수정
        return HStack(spacing: 0) {
            Text(ingredient.name)
                .headerFont4()
            Spacer().frame(width: ingredientNameRightSpace)
            switch divisionCase {
            case .이상반응재료:
                Text("00/00")
                    .tagFont()
                    .foregroundColor(.defaultText_wh)
                    .symmetricBackground(HPad: dateTextHorizontalPadding,
                                         VPad: dateTextVerticalPadding,
                                         color: .accentColor1,
                                         radius: dateBackgroundRadius)
            case .자주사용한재료:
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.accentColor1)
                    .scaledToFit()
                    .frame(width: 20)
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
            }   // end of switch
            Spacer()
            
            ButtonComponents(.clickableTiny, disabledCondition: buttonDisableCondition, isClicked: isClicked) {
                addIngredient(ingredient: ingredient)
            }
        }
    }
}

