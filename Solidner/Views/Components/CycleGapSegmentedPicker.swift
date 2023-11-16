//
//  CycleGapSegmentedPicker.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import Foundation
import SwiftUI

struct CycleGapSegmentedPicker<Data, Content> : View where Data: Hashable, Content: View {
    private enum Cycles: Int, CaseIterable {
        case one = 1, two, three, four
        var description: String {
            "\(self.rawValue)일"
        }
    }

    private enum K {
        static var rectangleShadowOpacity: CGFloat { 0.1 }
        static var rectangleShadowRadius: CGFloat { 2 }
        static var rectangleShadowX: CGFloat { 1 }
        static var rectangleShadowY: CGFloat { 1 }
        static var rectangleAnimationSpeed: CGFloat { 1.5 }
        static var rectangleOffsetY: CGFloat { 0 }
        static var rectangleFrameHeight: CGFloat { 38 }
        static var rectangleFrameWidth: CGFloat { 56 }
        static var itemsHstackSpacing: CGFloat { 0 }
        static var itemsPaddingVertical: CGFloat { 0 }
        static var itemsPaddingHorizontal: CGFloat { 0 }
        static var itemsAnimationDuration: CGFloat { 0.15 }
    }
    
    let sources: [Data]
    @Binding var selection: Data
    private let itemBuilder: (Data) -> Content

    private let backgroundColor: Color = .clear
    private let cornerRadius: CGFloat = 12
    private let borderWidth: CGFloat = 1

    init(
        _ sources: [Data],
        selection: Binding<Data>,
        @ViewBuilder itemBuilder: @escaping (Data) -> Content
    ) {
        self.sources = sources
        self._selection = selection
        self.itemBuilder = itemBuilder
    }

    var body: some View {
        ZStack(alignment: .center) {
            if let selectedIdx = sources.firstIndex(of: selection) {

                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .padding(EdgeInsets(top: borderWidth, leading: borderWidth, bottom: borderWidth, trailing: borderWidth))
                        .foregroundColor(.accentColor)
                        .frame(width: geo.size.width / CGFloat(sources.count))
                        .shadow(color: .black.opacity(K.rectangleShadowOpacity), radius: K.rectangleShadowRadius, x: K.rectangleShadowX, y: K.rectangleShadowY)
                        .animation(.spring().speed(K.rectangleAnimationSpeed), value: selectedIdx)
                        .offset(x: geo.size.width / CGFloat(sources.count) * CGFloat(selectedIdx), y: K.rectangleOffsetY)
                }
                .frame(height: K.rectangleFrameHeight)
            }

            HStack(spacing: K.itemsHstackSpacing) {
                ForEach(sources, id: \.self) { item in
                    itemBuilder(item)
                        .foregroundColor(selection == item ? .white : .gray)
                        .padding(.vertical, K.itemsPaddingVertical)
                        .padding(.horizontal, K.itemsPaddingHorizontal)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: K.itemsAnimationDuration)) {
                                selection = item
                            }
                        }
                }
            }
        }
    }
}

