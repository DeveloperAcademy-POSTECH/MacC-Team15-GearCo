//
//  SolidnerSegmentedPicker.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import SwiftUI

struct SolidnerSegmentedCyclePicker: View {
    @ObservedObject var user: UserOB
    @State private var selection: CycleGaps

    init(user: UserOB) {
        self.user = user
        self._selection = State(initialValue: user.planCycleGap)
    }

    var body: some View {
        SolidnerSegmentedPicker(
            label: TextLiterals.PlanBatchSetting.testCycleLabel,
            items: CycleGaps.allCases,
            selection: $selection
        )
        .onChange(of: selection) { value in
            user.planCycleGap = selection
        }
    }
}


struct SolidnerSegmentedDisplayDateTypePicker: View {
    @ObservedObject var user: UserOB
    @State private var selection: DisplayDateType

    init(user: UserOB) {
        self.user = user
        self._selection = State(initialValue: user.displayDateType)
    }

    var body: some View {
        SolidnerSegmentedPicker(
            label: TextLiterals.PlanBatchSetting.displayDateTypeLabel,
            items: DisplayDateType.allCases,
            selection: $selection
        )
        .onChange(of: selection) { value in
            user.displayDateType = selection
        }
    }
}

struct SolidnerSegmentedPicker<Data> : View where Data: Hashable & CustomStringConvertible {
    let label: String
    let items: [Data]
    @Binding var selection: Data
    @State private var segmentWidths: [CGFloat] = []

    private enum K {
        static var labelTextColor: Color { .defaultText }

        static var segmentedPickerHStackSpacing: CGFloat { 12 }
        static var textHorizontalPadding: CGFloat { 16 }
        static var textVerticalPadding: CGFloat { 10 }
        
        static var selectedTextColor: Color { Color.defaultText_wh }
        static var unselectedTextColor: Color { Color.defaultText.opacity(0.4) }

        static var highlightBackgroundColor: Color { .accentColor1 }
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
            .headerFont4()
            .foregroundStyle(K.labelTextColor)
    }

    private var segmentedPicker: some View {
        HStack(alignment: .center, spacing: K.segmentedPickerHStackSpacing) {
            ForEach(items, id: \.self) { item in
                Text(item.description)
                    .headerFont6()
                    .padding(horizontal: K.textHorizontalPadding, vertical: K.textVerticalPadding)
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
        let offsetX = totalWidthBefore +  CGFloat(Int(index)) * K.segmentedPickerHStackSpacing

        return RoundedRectangle(cornerRadius: K.highlightCornerRadius)
            .fill(K.highlightBackgroundColor)
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
        SolidnerSegmentedCyclePicker(user: UserOB())
    }
}
