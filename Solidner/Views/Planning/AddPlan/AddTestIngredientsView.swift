//
//  AddTestIngredientsView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

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
    
    @EnvironmentObject var user: UserOB
    @EnvironmentObject var mealOB: MealOB
    
    // init property
    let viewType: MealOB.IngredientTestType
    @Environment(\.dismiss) private var dismiss
    // 선택된 테스트 재료
    @State private var selectedIngredients: [Int] = []
    
    init(_ addIngredientViewType: MealOB.IngredientTestType) {
        self.viewType = addIngredientViewType
    }
    
    
    // MARK: body
    var body: some View {
        VStack(spacing: 0) {
            BackButtonAndTitleHeader(title: Texts.testViewTitle)
            
            // MARK: 검색, 재료 타입 버튼
            searchAndIngredientTypeButtonsRow
            
            // MARK: 선택된 재료 타입 확인 Row
            selectedIngredientRow
            
            ScrollView {
                if viewType == .new {
                    // TODO: 추후 이상반응 기능 추가 시 활성화
//                    IngredientsBigDivision(case: .이상반응재료,
//                                           ingredients: $selectedIngredients,
//                                           viewType: viewType)
                } else {
                    IngredientsBigDivision(case: .자주사용한재료,
                                           ingredients: $selectedIngredients,
                                           viewType: viewType)
                }
                
                ThickDivider().padding(.vertical, divisionDividerVerticalPadding)
                
                IngredientsBigDivision(case: .먹을수있는재료,
                                       ingredients: $selectedIngredients,
                                       viewType: viewType)
                Spacer().frame(height: divisionDividerVerticalPadding)
                IngredientsBigDivision(case: .권장하지않는재료,
                                       ingredients: $selectedIngredients,
                                       viewType: viewType)
                
                Spacer().frame(height: reportButtonTopSpace)
                reportButton
                
                Spacer().frame(height: saveButtonTopSpace)
            }
            Group {
                Spacer().frame(height: saveButtonBottomSpace)
//                if isIngredientBad { toastMessage }
                ButtonComponents(.big, title: "저장") {
                    saveSelectedTestIngredient()
                }
            }.padding(.horizontal, viewHorizontalPadding)
            
        }.background(Color.mainBackgroundColor).toolbar(.hidden)
            .onAppear { initSelectedIngredient() }
    }
}

// MARK: View Components
extension AddTestIngredientsView {
//    private var toastMessage: some View {
//        HStack(spacing: 4.27) {
//            Image(assetName: .check)
//            Text("방금 고른 재료는 지금 재료와 궁합이 좋지 않아요!")
//                .customFont(.toast, color: .tertinaryText)
//            Spacer()
//        }
//        .padding(.leading, 12.25)
//        .frame(height: 48)
//        .withRoundedBackground(
//            cornerRadius: 12,
//            fill: Color.defaultText_wh,
//            strokeBorder: Color.listStrokeColor,
//            lineWidth: 1
//        )
//    }
    
    private var searchAndIngredientTypeButtonsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: typeButtonBetweenSpace) {
                searchButton
                ForEach(TempIngredientType.allCases, id: \.self) { ingredientType in
                    ingredientTypeButton(ingredientType.rawValue)
                }
            }.padding(.leading, viewHorizontalPadding)
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
                    }.padding(.leading, viewHorizontalPadding).padding(.bottom, selectedTypeBottomSpace)
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
    private func ingredientTypeButton(_ text: String) -> some View {
        let textHorizontalPadding: CGFloat = 17
        let buttonFrameHeight: CGFloat = 40
        let buttonBackgroundRadius: CGFloat = 27.5
        
        return Button {
            // TODO: 재료 분류에 따라 리스트 추가, 버튼 기능, 스크롤 따라가기, 선택여부따라 색 변경
        } label: {
            Text(text)
                .bodyFont2()
                .foregroundColor(.defaultText_wh)
                .padding(.horizontal, textHorizontalPadding)
                .frame(height: buttonFrameHeight)
                .background {
                    RoundedRectangle(cornerRadius: buttonBackgroundRadius)
                        .fill(Color.secondaryText)
                    //                        .fill(Color.defaultText_wh)
                }
        }
    }
    
    // MARK: 검색 버튼
    private var searchButton: some View {
        let searchIconSize: CGFloat = 20
        let buttonFrameWidth: CGFloat = 70
        let buttonFrameHeight: CGFloat = 40
        let searchButtonBackgroundRadius: CGFloat = 24
        let searchButtonStrokeLineWidth: CGFloat = 1
        
        return Button {
            // TODO: Search
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
        
        // TODO: 재료 타입에 따른 color가 되도록 수정
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
        
        dismiss()
    }
    
    private func initSelectedIngredient() {
        switch viewType {
        case .new:
            for ingredient in mealOB.newIngredients {
                selectedIngredients.append(ingredient.id)
            }
        case .old:
            for ingredient in mealOB.oldIngredients {
                selectedIngredients.append(ingredient.id)
            }
        }
    }
}

extension AddTestIngredientsView {
    // MARK: IngredientType
    enum TempIngredientType: String, CaseIterable {
        case 이상반응재료 = "이상 반응 재료"
        case 곡류 = "곡류"
        case 채소류 = "채소류"
        case 과일류 = "과일류"
        case 육어류 = "육류&어류"
        case 유제품류 = "유제품류"
        case 기타 = "기타"
    }
}
