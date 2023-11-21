//
//  AddTestIngredientsView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/21.
//

import SwiftUI

struct AddTestIngredientsView: View {
    private let Texts = TextLiterals.AddIngredientsView.self
    // TODO: 형식 수정
    @State private var selectedIngredientPair: (first: String, second: String?)? = ("곡물", nil)
    
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader(title: Texts.testViewTitle)
                .padding(.bottom, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    searchButton
                    ForEach(TempIngredientType.allCases, id: \.self) { ingredientType in
                        ingredientTypeButton(ingredientType.rawValue)
                    }
                }.padding(.leading, 20)
            }.padding(.bottom, 15)
            
            if let pair = selectedIngredientPair {
                HStack(spacing: 0) {
                    Text("\(pair.first)")
                        .font(.caption)
                }
            }
            
            Spacer().frame(height: 30)
            ScrollView {
                VStack(spacing: 0) {
                    Text("이상 반응 재료")
                        .font(.title2)
                        .bold()
                }.padding(.horizontal, 20)
            }
        }.background(Color.mainBackgroundColor)
    }
    
    private func ingredientTypeButton(_ text: String) -> some View {
        let textHorizontalPadding: CGFloat = 17
        let buttonFrameHeight: CGFloat = 40
        let buttonBackgroundRadius: CGFloat = 27.5
        
        return Button {
            // TODO: Change State of Button
        } label: {
            // TODO: Color Change, font setting
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .medium))
                .padding(.horizontal, textHorizontalPadding)
                .frame(height: buttonFrameHeight)
                .background {
                    RoundedRectangle(cornerRadius: buttonBackgroundRadius)
                        .fill(Color.black)
                }
        }
    }
    
    private var searchButton: some View {
        let searchIconSize: CGFloat = 20
        let searchIconHorizontalPadding: CGFloat = 25
        let buttonFrameHeight: CGFloat = 40
        let searchButtonBackgroundRadius: CGFloat = 24
        let searchButtonStrokeInset: CGFloat = 0.5
        let searchButtonStrokeLineWidth: CGFloat = 1
        
        return Button {
            // TODO: Search
        } label: {
            // TODO: Color Change, font setting
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: searchIconSize)
                .foregroundColor(.gray)
                .padding(.horizontal, searchIconHorizontalPadding)
                .frame(height: buttonFrameHeight)

                .background {
                    RoundedRectangle(cornerRadius: searchButtonBackgroundRadius)
                        .fill(Color.mainBackgroundColor)
                }.overlay {
                    RoundedRectangle(cornerRadius: searchButtonBackgroundRadius)
                        .inset(by: searchButtonStrokeInset)
                        .stroke(.black.opacity(0.1), lineWidth: searchButtonStrokeLineWidth)
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

struct AddTestIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTestIngredientsView()
    }
}
