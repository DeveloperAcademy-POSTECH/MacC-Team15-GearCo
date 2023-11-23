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

enum DivisionCase: String {
    case 이상반응재료 = "이상 반응 재료"
    case 먹을수있는재료 = "먹을 수 있는 재료"
    case 권장하지않는재료 = "권장하지 않는 재료"
    case 자주사용한재료 = "자주 사용한 재료"
}

struct IngredientsBigDivision: View {
    private let Texts = TextLiterals.AddIngredientsView.self
    let divisionCase: DivisionCase
    
    private let titleTopSpace: CGFloat = 16
    private let viewHorizontalPadding: CGFloat = 20
    private let titleBottomSpace: CGFloat = 24
    private let rowBetweenSpace: CGFloat = 30
    private let divisionBottomSpace: CGFloat = 16
    
    private let foldSectionTitleVerticalPadding: CGFloat = 24
    private let foldSectionLightDividerBottomSpace: CGFloat = 20
    private let divisionTitleBottomSpace: CGFloat = 14
    private let divisionSubTitleBottomSpace: CGFloat = 4
    
    private let divierTopSpaceWhenNotFolded: CGFloat = 10
    
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
    
    // TODO: Dummy Data change
    @State private var foldStates: [Bool] = [false, false, false, false]
    
    private func toggleFoldState(foldStateList: inout [Bool], index: Int) {
        foldStateList[index].toggle()
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
            Text(divisionCase.rawValue)
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: divisionTitleBottomSpace)
            Text(explainText)
                .bodyFont2()
                .foregroundColor(.defaultText.opacity(0.6))
            Spacer().frame(height: divisionSubTitleBottomSpace)
            
            ForEach(foldStates.indices, id: \.self) { index in
                HStack(spacing: 0) {
                    Button {
                        withAnimation(.spring()) {
                            toggleFoldState(foldStateList: &foldStates, index: index)
                        }
                    } label: {
                        Text("곡류")
                            .font(.system(size: 19, weight: .semibold))
                            .padding(.trailing, 6)
                        Spacer()
                        Image(systemName: foldStates[index] ? "chevron.up" : "chevron.down")
                            .resizable()
                            .bold()
                            .frame(width: 18, height: 10)
                    }.foregroundColor(.black)
                        .toggleStyle(.automatic)
                }.buttonStyle(PlainButtonStyle())   // 깜빡임 제거
                .padding(.vertical, foldSectionTitleVerticalPadding)
                
                if foldStates[index] {
                    Divider()
                        .padding(.bottom, foldSectionLightDividerBottomSpace)
                    Group {
                        ForEach(Range<Int>(1...4)) { i in
                            ingredientSelectRow(divisionCase: divisionCase)
                            if(i != 4) {
                                Spacer().frame(height: rowBetweenSpace)
                            } else {
                                Spacer().frame(height: divisionBottomSpace)
                            }
                        }
                    }.transition(.push(from: foldStates[index] ? .bottom : .top))
                }
                
                ThickDivider().if(foldStates[index]) { view in
                    view.padding(.top, divierTopSpaceWhenNotFolded)
                }
            }
        }
    }
    
    private func 자주사용한재료Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text("자주 사용한 재료")
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: titleBottomSpace)
            // TODO: 실제 데이터로 변경
            ForEach(Range<Int>(1...4)) { i in
                ingredientSelectRow(divisionCase: .자주사용한재료)
                if(i != 4) {
                    Spacer().frame(height: rowBetweenSpace)
                } else {
                    Spacer().frame(height: divisionBottomSpace)
                }
            }
        }
    }
    
    private func 이상반응재료Division() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: titleTopSpace)
            Text("이상 반응 재료")
                .headerFont2()
                .foregroundColor(.defaultText)
            Spacer().frame(height: titleBottomSpace)
            // TODO: 실제 데이터로 변경
            ForEach(Range<Int>(1...4)) { i in
                ingredientSelectRow(divisionCase: .이상반응재료)
                if(i != 4) {
                    Spacer().frame(height: rowBetweenSpace)
                } else {
                    Spacer().frame(height: divisionBottomSpace)
                }
            }
        }
    }
}

func ingredientSelectRow(divisionCase: DivisionCase) -> some View {
    let dateTextHorizontalPadding: CGFloat = 5
    let dateTextVerticalPadding: CGFloat = 2.5
    let dateBackgroundRadius: CGFloat = 3.8
    
    let ingredientNameRightSpace: CGFloat = 6
    
    // TODO: 텍스트 수정 요함
    return HStack(spacing: 0) {
        Text("재료명")
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
            Text("6개월 +")
                .tagFont()
                .foregroundColor(.defaultText_wh)
                .symmetricBackground(HPad: dateTextHorizontalPadding,
                                     VPad: dateTextVerticalPadding,
                                     color: .ageColor,
                                     radius: dateBackgroundRadius)
        }   // end of switch
        Spacer()
        
        ButtonComponents(.clickableTiny, disabledCondition: false) {
            // TODO: 재료 추가
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
