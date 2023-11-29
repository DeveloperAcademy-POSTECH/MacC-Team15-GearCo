//
//  ColoredIngredientsText.swift
//  Solidner
//
//  Created by sei on 11/24/23.
//

import SwiftUI

struct ColoredIngredientsText: View {
    let newIngredients: [Ingredient]
    let oldIngredients: [Ingredient]
    let accentColor: Color
    let normalColor: Color

    enum ColoredIngredientsTextType {
        case chip, cell
    }

    @State private(set) var textType: Text.CustomFontType? = .header5
    func customFont(_ type: Text.CustomFontType) -> ColoredIngredientsText {
        var view = self
        view._textType = State(initialValue: type)
        return view
    }

    var body: some View {
        (newIngredientsText + bridgeText + oldIngredientsText)
            .customFont(textType)
            .lineLimit(1)
    }

    private var newIngredientsText: Text {
        ingredientsText(of: newIngredients, accentColor: accentColor)
    }

    private var bridgeText: Text {
        if(newIngredients.count == 0) {
            return K.emptyText
        } else {
            return K.commaText.foreground(color: normalColor)
        }
    }

    private var oldIngredientsText: Text {
        ingredientsText(of: oldIngredients, accentColor: normalColor)
    }

    private func ingredientsText(of ingredients: [Ingredient], accentColor: Color) -> Text {
        let lastIndex = ingredients.endIndex - 1
        return ingredients.enumerated().reduce(K.emptyText) { partialResult, enumeration in
            let (index, ingredient) = (enumeration.offset, enumeration.element)
            let ingredientsText = Text(ingredient.name).foreground(color: accentColor)
            let additionalText = ((index == lastIndex) ? K.emptyText : K.commaText).foreground(color: normalColor)
            return partialResult + ingredientsText + additionalText
        }
    }
}

// Custom Initializer

extension ColoredIngredientsText {
    init(
        mealPlan: MealPlan,
        accentColor: Color = .accentColor1,
        normalColor: Color = .defaultText,
        type: ColoredIngredientsTextType = .cell
    ) {
        self.newIngredients = mealPlan.newIngredients
        self.oldIngredients = mealPlan.oldIngredients
        self.accentColor = accentColor
        self.normalColor = normalColor
        self._textType = State(initialValue: type == .cell ? .header5 : .body3)
    }
}

extension ColoredIngredientsText {
    private enum K {
        static var emptyText: Text { Text("") }
        static var commaText: Text { Text(", ") }

    }
}

//struct ColoredIngredientsText_PreviewProvider: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ColoredIngredientsText(mealPlan: .mockMealsOne[0])
//            ColoredIngredientsText(mealPlan: .mockMealsOne[1])
//            ColoredIngredientsText(mealPlan: .mockMealsOne[2])
//                .customFont(.body3)
//        }
//    }
//}
