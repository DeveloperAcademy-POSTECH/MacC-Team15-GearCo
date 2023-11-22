//
//  SolidnerSegmentedPicker.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI


struct SolidnerSegmentedPicker<Data> : View where Data: Hashable & CustomStringConvertible {
    let label: String
    let items: [Data]
    @Binding var selection: Data
    @State private var segmentWidths: [CGFloat] = []

    private enum K {
        static var hStackSpacing: CGFloat { 12 }
        static var textHorizontalPadding: CGFloat { 16 }
        static var textVerticalPadding: CGFloat { 10 }
        static var selectedTextColor: Color { Color.white }
        static var unselectedTextColor: Color { Color.black }
        static var highlightCornerRadius: CGFloat { 12 }
    }

    var body: some View {
        HStack {
            labelText
            Spacer()
            segmentedPicker
        }
    }

    private var labelText: some View {
        Text(label)
    }

    private var segmentedPicker: some View {
        HStack(alignment: .center, spacing: K.hStackSpacing) {
            ForEach(items, id: \.self) { item in
                Text(item.description)
                    .padding(.horizontal, K.textHorizontalPadding)
                    .padding(.vertical, K.textVerticalPadding)
                    .foregroundStyle(selection == item ? K.selectedTextColor : K.unselectedTextColor)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(key: SolidnerSegmentWidthKey.self, value: [geometry.size.width])
                    })
                    .onTapGesture {
                        withAnimation {
                            selection = item
                        }
                    }
            }
        }
        .backgroundPreferenceValue(SolidnerSegmentWidthKey.self) { preferences in
            GeometryReader { geometry in
                createHighlightOverlay(geometry: geometry, preferences: preferences)
            }
        }
    }

    private func createHighlightOverlay(geometry: GeometryProxy, preferences: [CGFloat]) -> some View {
        let widths = preferences
        let index = items.firstIndex(of: selection) ?? .zero
        let totalWidthBefore = widths.prefix(index).reduce(.zero, +)
        let offsetX = totalWidthBefore +  CGFloat(Int(index)) * K.hStackSpacing

        return RoundedRectangle(cornerRadius: K.highlightCornerRadius)
            .fill(Color.accentColor)
            .frame(width: widths[index])
            .offset(x: offsetX, y: .zero)
    }
}

fileprivate struct SolidnerSegmentWidthKey: PreferenceKey {
    typealias Value = [CGFloat]
    static var defaultValue: [CGFloat] = []

    static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        value.append(contentsOf: nextValue())
    }
}

struct SolidnerSegmentedPicker_Previews: PreviewProvider {
    static var previews: some View {
//        SolidnerSegmentedPicker(label: "간격", items: [1, 2, 3], selection: .constant(1))
    }
}
