//
//  AddTestIngredientsView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

struct AddTestIngredientsView: View {
    // TODO: 전체적인 Padding 계층 및 Magic Number 수정 요함
    private let Texts = TextLiterals.AddIngredientsView.self
    
    // MARK: Padding&Spacing Magic Numbers
    private let viewHorizontalPadding: CGFloat = 20
    
    private let headerBottomPadding: CGFloat = 20
    private let typeButtonsRowBottomPadding: CGFloat = 17
    private let typeButtonBetweenSpace: CGFloat = 10
    
    private let selectedTypeBottomSpace: CGFloat = 25
    private let selectedTypeSpaceWhenDisappear: CGFloat = 30
    private let divisionDividerVerticalPadding: CGFloat = 10
    
    private let saveButtonBottomSpace: CGFloat = 40
    private let saveButtonTopSpace: CGFloat = 100
    private let reportButtonTopSpace: CGFloat = 20
        
    // TODO: 형식 수정
    @State private var selectedIngredientPair: (first: String, second: String?)? = ("곡물", "유제품류")
    
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader(title: Texts.testViewTitle)
                .padding(.bottom, headerBottomPadding)
            
            // MARK: 검색, 재료 타입 버튼
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: typeButtonBetweenSpace) {
                    searchButton
                    ForEach(TempIngredientType.allCases, id: \.self) { ingredientType in
                        ingredientTypeButton(ingredientType.rawValue)
                    }
                }.padding(.leading, viewHorizontalPadding)
            }.padding(.bottom, typeButtonsRowBottomPadding)
            
            // MARK: 선택된 재료 타입 확인 Row
            if let pair = selectedIngredientPair {
                HStack(spacing: typeButtonBetweenSpace) {
                    selectedIngredientTypeBox(typeText: pair.first)
                    if let second = pair.second {
                        selectedIngredientTypeBox(typeText: second)
                    }
                    Spacer()
                }.padding(.leading, viewHorizontalPadding)
                
                Spacer().frame(height: selectedTypeBottomSpace)
            } else {
                Spacer().frame(height: selectedTypeSpaceWhenDisappear)
            }
            
            ScrollView {
                IngredientsBigDivision(divisionCase: .이상반응재료)
//                IngredientsBigDivision(divisionCase: .자주사용한재료)
                
                ThickDivider().padding(.vertical, divisionDividerVerticalPadding)
                
                IngredientsBigDivision(divisionCase: .먹을수있는재료)
                Spacer().frame(height: divisionDividerVerticalPadding)
                IngredientsBigDivision(divisionCase: .권장하지않는재료)
                
                Spacer().frame(height: reportButtonTopSpace)
                reportButton
                
                Spacer().frame(height: saveButtonTopSpace)
                ButtonComponents(.big).padding(.horizontal, viewHorizontalPadding)
                Spacer().frame(height: saveButtonBottomSpace)
            }
        }.background(Color.mainBackgroundColor)
    }
    
    private var reportButton: some View {
        Button {
            // TODO: 재료 신고 기능
        } label: {
            Text(Texts.isIngredientNotExist)
                .clickableTextFont2()
                .underline()
                .foregroundColor(.primary.opacity(0.3))
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

/// 선택된 재료들의 구분을 표시하는 블럭을 return합니다.
/// - Parameter typeText: 표시될 text
/// - Returns: 선택된 재료 확인 box
func selectedIngredientTypeBox(typeText: String) -> some View {
    let horizontalPadding: CGFloat = 12
    let verticalPadding: CGFloat = 7
    let cornerRadius: CGFloat = 6
    
    // TODO: 재료 타입에 따른 color가 되도록 수정
    return Text("\(typeText)")
        .bodyFont3()
        .foregroundColor(.secondaryText)
        .symmetricBackground(HPad: horizontalPadding,
                             VPad: verticalPadding,
                             color: .grain,
                             radius: cornerRadius)
}

struct AddTestIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTestIngredientsView()
    }
}
