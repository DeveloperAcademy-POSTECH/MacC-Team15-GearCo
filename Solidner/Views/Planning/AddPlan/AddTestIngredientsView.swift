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
    
    private let viewHorizontalPadding: CGFloat = 20
    
    @State private var dummyFoldState: [Bool] = [false, false, false, false]
    
    private func toggleFoldState(foldStateList: inout [Bool], index: Int) {
        foldStateList[index].toggle()
    }
    
    // TODO: 형식 수정
    @State private var selectedIngredientPair: (first: String, second: String?)? = ("곡물", "유제품류")
    
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader(title: Texts.testViewTitle)
                .padding(.bottom, 20)
            
            // MARK: 스크롤 위치 확인
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    searchButton
                    ForEach(TempIngredientType.allCases, id: \.self) { ingredientType in
                        ingredientTypeButton(ingredientType.rawValue)
                    }
                }.padding(.leading, viewHorizontalPadding)
            }.padding(.bottom, 15)
            
            if let pair = selectedIngredientPair {
                HStack(spacing: 10) {
                    selectedIngredientTypeBox(typeText: pair.first)
                    if let second = pair.second {
                        selectedIngredientTypeBox(typeText: second)
                    }
                    Spacer()
                }.padding(.leading, viewHorizontalPadding)
            }
            Spacer().frame(height: 15)

            ScrollView {
                Spacer().frame(height: 15)
                VStack(alignment: .leading, spacing: 0) {
                    Text("이상 반응 재료")
                        .font(.title2)
                        .bold()
                    
                    ingredientSelectRow().padding(.top, 24)
                    ingredientSelectRow().padding(.top, 30)
                }.padding(.horizontal, viewHorizontalPadding)
                
                ThickDivider()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("먹을 수 있는 재료")
                        .font(.title2)
                        .bold()
                    Text("아이가 섭취할 수 있는 재료의\n전체 목록이에요")
                        .padding(.top, 13)
                        .padding(.bottom, 30)
                    
                    ForEach(dummyFoldState.indices, id: \.self) { index in
                        HStack(spacing: 0) {
                            Button {
                                withAnimation(.spring()) {
                                    toggleFoldState(foldStateList: &dummyFoldState, index: index)
                                }
                            } label: {
                                Text("곡류")
                                    .font(.system(size: 19, weight: .semibold))
                                    .padding(.trailing, 6)
                                Spacer()
                                Image(systemName: dummyFoldState[index] ? "chevron.up" : "chevron.down")
                                    .resizable()
                                    .bold()
                                    .frame(width: 18, height: 10)
                            }.foregroundColor(.black)
                                .toggleStyle(.automatic)
                        }.buttonStyle(PlainButtonStyle())   // 깜빡임 제거
                        
                        if dummyFoldState[index] {
                            Divider()
                                .padding(.top, 24)
                                .padding(.bottom, 20)
                            Group {
                                ingredientSelectRow().padding(.bottom, 30)
                                ingredientSelectRow().padding(.bottom, 30)
                                ingredientSelectRow().padding(.bottom, 30)
                                ingredientSelectRow().padding(.bottom, 30)
                            }.transition(.push(from: dummyFoldState[index] ? .bottom : .top))
                                
                        }
                        
                        ThickDivider()
                    }
                    
                    
                }.padding(.horizontal, viewHorizontalPadding)
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

func ingredientSelectRow() -> some View {
    // TODO: 수정
    HStack(spacing: 0) {
        Text("재료명")
            .font(.system(size: 19, weight: .semibold))
            .padding(.trailing, 6)
        
        Text("00/00")
            .font(.caption)
            .bold()
            .foregroundColor(.white)
            .symmetricBackground(HPad: 5, VPad: 2.5, color: .pink, radius: 3.8)
        
        Spacer()
        
        Button {
            // TODO: 추가 로직, 색, 폰트 수정
        } label: {
            Text("재료 추가")
                .font(.system(size: 15))
                .symmetricBackground(HPad: 20, VPad: 15, color: .gray, radius: 12)
        }
    }
}

/// 선택된 재료들의 구분을 표시하는 블럭을 return합니다.
/// - Parameter typeText: 표시될 text
/// - Returns: 선택된 재료 확인 box
func selectedIngredientTypeBox(typeText: String) -> some View {
    let horizontalPadding: CGFloat = 12
    let verticalPadding: CGFloat = 7
    let cornerRadius: CGFloat = 6
    
    // TODO: font, color 수정
    return Text("\(typeText)")
        .font(.caption)
        .bold()
        .symmetricBackground(HPad: horizontalPadding,
                             VPad: verticalPadding,
                             color: .gray,
                             radius: cornerRadius)
}

struct AddTestIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        AddTestIngredientsView()
    }
}
