//
//  StartPlanView.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

// TODO: toolbar 어떻게 할거임??

import SwiftUI

struct StartPlanView: View {
    private let texts = TextLiterals.StartPlan.self
    @State private var isStartTapped = false

    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                Spacer().frame(height: K.topSpacerHeight)
                ingredientsImage
                titleAndHint
                goToPlanButton
            }
            .toolbar {
                toolbarItemLeading
                toolbarItemTrailing
            }
        }
    }

    private var toolbarItemLeading: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Image(assetName: .userInfo)
        }
    }

    private var toolbarItemTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Image(assetName: .calendar)
        }
    }

    private var ingredientsImage: some View {
        Image(assetName: .ingredientsInStart)
            .padding(.bottom, K.ingredientsImagePaddingBottom)
    }

    private var titleAndHint: some View {
        TitleAndHintView(
            type: .center12,
            title: texts.noWorriesJustStartHeaderText,
            hint: texts.noWorriesJustStartDetailText
        )
        .padding(.bottom, K.titleAndHintPaddingBottom)
    }

    private var goToPlanButton: some View {
        Button {
            isStartTapped = true
        } label: {
            goToPlanButtonLabel
        }
        .sheet(isPresented: $isStartTapped) {
            modal
        }
    }

    private var goToPlanButtonLabel: some View {
        Text(texts.goToPlanButtonText)
            .headerFont5()
            .foregroundStyle(Color.defaultText_wh)
            .padding(.horizontal, K.goToPlanButtonLabelPaddingHorizontal)
            .frame(height: K.goToPlanButtonLabelframeHeight)
            .background(
                RoundedRectangle(cornerRadius: K.goToPlanButtonLabelBackgroundCornerRadius)
                    .foregroundColor(K.goToPlanButtonLabelBackgroundColor)
            )
    }

    private var modal: some View {
        StartDateInitialSelectModal()
            .presentationDetents([.height(K.modalHeight)])
            .modify { view in
                if #available(iOS 16.4, *) {
                    view.presentationCornerRadius(K.modalPresentationCornerRadius)
                }
            }
    }
}

extension StartPlanView {
    private enum K {
        static var topSpacerHeight: CGFloat { 20 }
        static var ingredientsImagePaddingBottom: CGFloat { 45 }
        static var titleAndHintPaddingBottom: CGFloat { 30 }
        static var goToPlanButtonLabelPaddingHorizontal: CGFloat { 27 }
        static var goToPlanButtonLabelframeHeight: CGFloat { 60 }
        static var goToPlanButtonLabelBackgroundCornerRadius: CGFloat { 50 }
        static var goToPlanButtonLabelBackgroundColor: Color { .accentColor1 }
        static var modalHeight: CGFloat { 498 }
        static var modalPresentationCornerRadius: CGFloat { 25 }
    }
}

struct StartPlanView_Previews: PreviewProvider {
    static var previews: some View {
        StartPlanView().environmentObject(UserOB())
    }
}

