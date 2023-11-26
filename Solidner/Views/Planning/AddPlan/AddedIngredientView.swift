//
//  AddedIngredientView.swift
//  Solidner
//
//  Created by sei on 11/24/23.
//

import SwiftUI

struct AddedIngredientView: View {
    private let texts = TextLiterals.AddedIngredient.self

    enum AddedIngredientView {
        case age, new, adverseReactionDate, deletable, mismatch
    }

    let type: AddedIngredientView
    let ingredient: Ingredient

    var colorChip: some View {
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 16, height: 16)
            .foregroundStyle(ingredient.type.color)
    }

    var body: some View {
        HStack(spacing: 12) {
            colorChip
            ingredientName
            Spacer()
            if type == .deletable { deleteButton }
            else { ingredientBadge }
        }
        .padding(top: 0, leading: 15, bottom: 0, trailing: 20)
        .frame(height: 56)
        .background(background)
    }

    private var background: some View {
        Color.defaultText_wh
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var ingredientName: some View {
        Text(ingredient.name)
            .bodyFont1()
    }

    private var deleteButton: some View {
        Button {
            // delete ingredient action - 밖에서 받아오기
        } label: {
            Text(texts.deleteText)
                .foregroundStyle(Color.primeText.opacity(0.3))
        }
    }

    private var ingredientBadge: some View {
        switch type {
        case .age:
            let ageText = texts.canEatText(month: ingredient.ableMonth)
            return AnyView(badgeView(text: ageText, bgColor: .ageColor))
        case .new:
            return AnyView(badgeView(text: texts.newText, bgColor: .newColor))
        case .mismatch:
            return AnyView(misMatchBadgeView())
        default:
//            case .adverseReactionDate, deletable:
            // TODO: - 나중에 이상반응 날짜 넣기
            let reactedDateString = {
                let reactedDate = Date()
                return texts.reactionDateText(of: reactedDate)
            }()
            return AnyView(badgeView(text: reactedDateString, bgColor: .accentColor1))
        }
    }
    private func misMatchBadgeView() -> some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundStyle(Color.accentColor1)
    }

    private func badgeView(text: String, bgColor: Color) -> some View {
        Text(text)
            .tagFont()
            .foregroundStyle(Color.defaultText_wh)
            .padding(top: 2, leading: 5, bottom: 3, trailing: 5)
            .background(
                RoundedRectangle(cornerRadius: 3.8)
                    .foregroundStyle(bgColor)
            )
    }
}


//struct AddedIngredientView_PreviewProvider: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 20) {
//            AddedIngredientView(type: .new, ingredient: .init(type: .어육류, name: "소고기"))
//            AddedIngredientView(type: .age, ingredient: .init(type: .어육류, name: "소고기"))
//            AddedIngredientView(type: .adverseReactionDate, ingredient: .init(type: .어육류, name: "소고기"))
//            AddedIngredientView(type: .deletable, ingredient: .init(type: .어육류, name: "소고기"))
//            AddedIngredientView(type: .mismatch, ingredient: .init(type: .어육류, name: "소고기"))
//        }
//        .padding()
//        .background(Color.secondBgColor)
//    }
//}
