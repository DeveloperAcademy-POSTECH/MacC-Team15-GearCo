//
//  AddTestIngredientsView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

// 스크롤 id 저장.
struct ScrollID {
    var 채소1: Namespace.ID
    var 과일1: Namespace.ID
    var 곡물1: Namespace.ID
    var 어육류1: Namespace.ID
    var 유제품1: Namespace.ID
    var 기타1: Namespace.ID
    var 채소2: Namespace.ID
    var 과일2: Namespace.ID
    var 곡물2: Namespace.ID
    var 어육류2: Namespace.ID
    var 유제품2: Namespace.ID
    var 기타2: Namespace.ID
    
    var namespaces1: [Namespace.ID] {
        return [채소1, 과일1, 곡물1, 어육류1, 유제품1, 기타1]
    }
    var namespaces2: [Namespace.ID] {
        return [채소2, 과일2, 곡물2, 어육류2, 유제품2, 기타2]
    }
}

struct AddTestIngredientsView: View {
    // TODO: 전체적인 Padding 계층 및 Magic Number 수정 요함
    private let ingredientData = IngredientData.shared.ingredients
    private let Texts = TextLiterals.AddIngredientsView.self
    
    // MARK: Padding&Spacing Magic Numbers
    private let viewHorizontalPadding: CGFloat = 20
    private let headerBottomPadding: CGFloat = 20
    private let typeButtonsRowBottomPadding: CGFloat = 17
    private let typeButtonBetweenSpace: CGFloat = 10
    private let selectedTypeBottomSpace: CGFloat = 25
    private let divisionDividerVerticalPadding: CGFloat = 10
    private let saveButtonBottomSpace: CGFloat = 16
    private let saveButtonTopSpace: CGFloat = 100
    private let reportButtonTopSpace: CGFloat = 20
    
    @State private var showReportSheet = false
    @State private var isSearching = false
    
    @EnvironmentObject private var user: UserOB
    @EnvironmentObject private var mealOB: MealOB
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    
    // init property
    let viewType: MealOB.IngredientTestType
    @Environment(\.dismiss) private var dismiss
    // 선택된 테스트 재료
    @State private var selectedIngredients: [Int] = []
    @State private var ingredientUseCount: [Int: Int] = [:]
    @State private var initialSelectedIngredients: [Int] = []
    
    init(_ addIngredientViewType: MealOB.IngredientTestType) {
        self.viewType = addIngredientViewType
    }
    
    var hasIngredientsMismatch: Bool {
        let ingredients = selectedIngredients.compactMap { ingredientData[$0] }
        let mismatches = Set(ingredients.flatMap { $0.misMatches })
        return ingredients.reduce(false) { partialResult, ingredient in
            partialResult || mismatches.contains(ingredient)
        }
    }
    
    @Namespace var 맨위
    @Namespace var 채소1
    @Namespace var 과일1
    @Namespace var 곡물1
    @Namespace var 어육류1
    @Namespace var 유제품1
    @Namespace var 기타1
    @Namespace var 채소2
    @Namespace var 과일2
    @Namespace var 곡물2
    @Namespace var 어육류2
    @Namespace var 유제품2
    @Namespace var 기타2
    @State var scrollID: ScrollID?
    
    @State private var selectedIngredientType: (Int, Bool) = (0, false)
    
    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            BackButtonAndTitleHeader(title: Texts.testViewTitle(viewType: viewType))
            
            ScrollViewReader { proxy in
                // MARK: 검색, 재료 타입 버튼
                searchAndIngredientTypeButtonsRow(proxy: proxy)
                
                // MARK: 선택된 재료 타입 확인 Row
                if !isSearching {
                    selectedIngredientRow
                }
                
                ScrollView {
                    Spacer().frame(height: selectedTypeBottomSpace)
                    if let scrollID = scrollID {
                        if isSearching {
                            IngredientsBigDivision(case: .검색,
                                                   ingredients: $selectedIngredients,
                                                   initSelected: initialSelectedIngredients,
                                                   mealOB: mealOB,
                                                   viewType: viewType,
                                                   ingredientUseCount: $ingredientUseCount,
                                                   scrollID: scrollID)
                        } else {
                            if viewType == .new {
                                // TODO: 추후 이상반응 기능 추가 시 활성화
                                //                    IngredientsBigDivision(case: .이상반응재료,
                                //                                           ingredients: $selectedIngredients,
                                //                                           viewType: viewType)
                            } else {
                                IngredientsBigDivision(case: .자주사용한재료,
                                                       ingredients: $selectedIngredients,
                                                       initSelected: initialSelectedIngredients,
                                                       mealOB: mealOB,
                                                       viewType: viewType,
                                                       ingredientUseCount: $ingredientUseCount,
                                                       scrollID: scrollID).id(맨위)
                                ThickDivider().padding(.vertical, divisionDividerVerticalPadding)
                            }
                            
                            IngredientsBigDivision(case: .먹을수있는재료,
                                                   ingredients: $selectedIngredients,
                                                   initSelected: initialSelectedIngredients,
                                                   mealOB: mealOB,
                                                   viewType: viewType,
                                                   ingredientUseCount: $ingredientUseCount,
                                                   scrollID: scrollID).id(맨위)
                            Spacer().frame(height: divisionDividerVerticalPadding)
                            IngredientsBigDivision(case: .권장하지않는재료,
                                                   ingredients: $selectedIngredients,
                                                   initSelected: initialSelectedIngredients,
                                                   mealOB: mealOB,
                                                   viewType: viewType,
                                                   ingredientUseCount: $ingredientUseCount,
                                                   scrollID: scrollID)
                            
                            Spacer().frame(height: reportButtonTopSpace)
                            reportButton
                            
                            Spacer().frame(height: saveButtonTopSpace)
                        }
                    }
                }
                Spacer().frame(height: saveButtonBottomSpace)
            }
            Group {
                if hasIngredientsMismatch { toastMessage }
//                ButtonComponents(.big, title: "저장") {
//                    saveSelectedTestIngredient()
//                }.defaultBottomPadding()
            }
            .padding(.horizontal, viewHorizontalPadding)
        }
        .background(Color.secondBgColor)
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar(.hidden)
            .onAppear {
                initSelectedIngredient()
                countingIngredientUse()
            }.task {
                scrollID = ScrollID(채소1: 채소1, 과일1: 과일1, 곡물1: 곡물1, 어육류1: 어육류1, 유제품1: 유제품1, 기타1: 기타1,
                                    채소2: 채소2, 과일2: 과일2, 곡물2: 곡물2, 어육류2: 어육류2, 유제품2: 유제품2, 기타2: 기타2)
            }
    }
}

// MARK: View Components
extension AddTestIngredientsView {
    
    private var toastMessage: some View {
        ToastMessage(type: .warnMismatch)
            .padding(.bottom, 20.responsibleHeight)
    }

    private func searchAndIngredientTypeButtonsRow(proxy: ScrollViewProxy) -> some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: typeButtonBetweenSpace) {
                searchButton(proxy: proxy)
                ForEach(Array(IngredientType.allCases.enumerated()), id: \.element) { index, type in
                    ingredientTypeButton(proxy, type.description, namespace: index, recommend: true)
                }
                ForEach(Array(IngredientType.allCases.enumerated()), id: \.element) { index, type in
                    ingredientTypeButton(proxy, type.description, namespace: index, recommend: false)
                }
            }.padding(.horizontal, viewHorizontalPadding)
        }.padding(.bottom, typeButtonsRowBottomPadding)
    }
    
    private var selectedIngredientRow: some View {
        if !selectedIngredients.isEmpty {
            return AnyView(
                VStack(alignment: .leading, spacing: 0) {
                    ScrollView(.horizontal) {
                        HStack(spacing: typeButtonBetweenSpace) {
                            ForEach(selectedIngredients.indices, id: \.self) { i in
                                let data = ingredientData[selectedIngredients[i]]!
                                selectedIngredientTypeBox(ingredient: data)
                            }
                        }
                    }
                    .padding(.leading, viewHorizontalPadding)
//                    .padding(.bottom, selectedTypeBottomSpace)
                }
            )
        }
        return AnyView(EmptyView())
    }
    
    private var reportButton: some View {
        Button {
            showReportSheet = true
        } label: {
            Text(Texts.isIngredientNotExist)
                .clickableTextFont2()
                .underline()
                .foregroundColor(.primary.opacity(0.3))
        }.sheet(isPresented: $showReportSheet) {
            ReportIngredientModalView()
        }
    }
    
    // MARK: 테스트 재료 분류
    private func ingredientTypeButton(_ proxy: ScrollViewProxy, _ text: String, namespace index: Int, recommend: Bool) -> some View {
        let textHorizontalPadding: CGFloat = 17
        let buttonFrameHeight: CGFloat = 40
        let buttonBackgroundRadius: CGFloat = 27.5
        let textAndMarkSpace: CGFloat = 4
        let buttonTrailingPadding: CGFloat = 13
        
        return Button {
            // TODO: 재료 분류에 따라 리스트 추가, 버튼 기능, 스크롤 따라가기, 선택여부따라 색 변경
            withAnimation {
                if recommend {
                    proxy.scrollTo(scrollID?.namespaces1[index], anchor: .top)
                } else {
                    proxy.scrollTo(scrollID?.namespaces2[index], anchor: .top)
                }
            }
        } label: {
            HStack(spacing: 0) {
                Text(text)
                    .bodyFont2()
                    .foregroundColor(.defaultText.opacity(0.6))
                    .frame(height: buttonFrameHeight)
                Spacer().frame(width: textAndMarkSpace)
                if !recommend {
                    Image(systemName: "xmark.shield.fill")
                        .foregroundStyle(Color.ageColor)
                        .scaledToFit()
                        .frame(width: 20)
                }
            }.padding(.leading, textHorizontalPadding)
            .padding(.trailing, buttonTrailingPadding)
            .background {
                RoundedRectangle(cornerRadius: buttonBackgroundRadius)
//                    .fill(Color.secondaryText)
                        .fill(Color.defaultText_wh)
            }
        }
    }
    
    // MARK: 검색 버튼
    private func searchButton(proxy: ScrollViewProxy) -> some View {
        let searchIconSize: CGFloat = 20
        let buttonFrameWidth: CGFloat = 70
        let buttonFrameHeight: CGFloat = 40
        let searchButtonBackgroundRadius: CGFloat = 24
        let searchButtonStrokeLineWidth: CGFloat = 1
        
        return Button {
            withAnimation {
                proxy.scrollTo(맨위, anchor: .top)
                isSearching.toggle()
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: searchIconSize)
                .foregroundColor(.tertinaryText)
                .frame(width: buttonFrameWidth, height: buttonFrameHeight)
                .background {
                    RoundedRectangle(cornerRadius: searchButtonBackgroundRadius)
                        .fill(Color.buttonBgColor, strokeBorder: Color.buttonStrokeColor, lineWidth: searchButtonStrokeLineWidth)
                }
        }
    }
    
    /// 선택된 재료들의 구분을 표시하는 블럭을 return합니다.
    /// - Parameter typeText: 표시될 text
    /// - Returns: 선택된 재료 확인 box
    func selectedIngredientTypeBox(ingredient: Ingredient) -> some View {
        let horizontalPadding: CGFloat = 12
        let verticalPadding: CGFloat = 7
        let cornerRadius: CGFloat = 6
        
        return Text("\(ingredient.name)")
            .bodyFont3()
            .foregroundColor(.secondaryText)
            .symmetricBackground(HPad: horizontalPadding,
                                 VPad: verticalPadding,
                                 color: ingredient.type.color,
                                 radius: cornerRadius)
    }
}

// MARK: Functions
extension AddTestIngredientsView {
    
    private func saveSelectedTestIngredient() {
        mealOB.clearIngredient(in: viewType)
        for i in selectedIngredients {
            let ingredient = ingredientData[i]!
            mealOB.addIngredient(ingredient: ingredient, in: viewType)
        }
        
//        dismiss()
    }
    
    private func initSelectedIngredient() {
        switch viewType {
        case .new:
            for ingredient in mealOB.newIngredients {
                selectedIngredients.append(ingredient.id)
            }
            initialSelectedIngredients = selectedIngredients
        case .old:
            for ingredient in mealOB.oldIngredients {
                selectedIngredients.append(ingredient.id)
            }
            initialSelectedIngredients = selectedIngredients
        }
    }
    
    // 재료 사용 횟수 카운팅
    private func countingIngredientUse() {
        for plan in mealPlansOB.mealPlans {
            for ingredient in plan.newIngredients {
                ingredientUseCount[ingredient.id, default: 0] += 1
            }
            for ingredient in plan.oldIngredients {
                ingredientUseCount[ingredient.id, default: 0] += 1
            }
        }
    }
}
