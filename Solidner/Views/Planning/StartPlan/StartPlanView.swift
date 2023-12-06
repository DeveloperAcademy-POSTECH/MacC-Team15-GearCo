//
//  StartPlanView.swift
//  Solidner
//
//  Created by sei on 11/21/23.
//

// TODO: toolbar 어떻게 할거임??

import SwiftUI

struct StartPlanView: View {
    @EnvironmentObject private var mealPlansOB: MealPlansOB
    private let texts = TextLiterals.StartPlan.self
    @State private var startDate = Date()
    @State private var isStartTapped = false
    @State private var isMyPageOpenning = false
    @State private var isPlanStarting = false
    
    var body: some View {
        RootDefaultSpacingVStack {
            viewHeader
            viewBody
        }
    }
    
    var viewHeader: some View {
        LeftRightButtonHeader(
            leftButton: viewHeaderLeftButton,
            rightButton: viewHeaderRightButton
        )
    }
    
    var viewBody: some View {
        VStack(spacing: .zero) {
            Spacer()
            ingredientsImage
            titleAndHint
            goToPlanButton
            Spacer().frame(height: K.buttonBottomSpace)
        }
        .navigationDestination(isPresented: $isMyPageOpenning) {
            MypageRootView()
        }
        .navigationDestination(isPresented: $isPlanStarting) {
            MealDetailView(startDate: startDate, cycleGap: .three, mealPlansOB: mealPlansOB)
        }
    }

    private var viewHeaderLeftButton: some View {
        Button {
            isMyPageOpenning = true
        } label: {
            Image(.userInfo)
        }
    }

    private var viewHeaderRightButton: some View {
        Button { } label: {
            Image(.calendarInPlanList).opacity(0.2)
        }
        .disabled(true)
    }
    
    private var ingredientsImage: some View {
        Image(assetName: .ingredientsInStart)
            .resizable()
            .aspectRatio(contentMode: .fit)
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
        StartDateInitialSelectModal(
            currentDate: $startDate,
            isPlanStarting: $isPlanStarting
        )
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
        static var topSpacerHeight: CGFloat { 20.responsibleHeight }
        static var ingredientsImagePaddingBottom: CGFloat { 45.responsibleHeight }
        static var titleAndHintPaddingBottom: CGFloat { 30.responsibleHeight }
        static var goToPlanButtonLabelPaddingHorizontal: CGFloat { 27.responsibleWidth }
        static var goToPlanButtonLabelframeHeight: CGFloat { 60.responsibleHeight }
        static var goToPlanButtonLabelBackgroundCornerRadius: CGFloat { 50 }
        static var goToPlanButtonLabelBackgroundColor: Color { .accentColor1 }
        static var modalHeight: CGFloat { 498 }
        static var modalPresentationCornerRadius: CGFloat { 25 }
        static var buttonBottomSpace: CGFloat { 35.responsibleHeight }
    }
}

struct StartPlanView_Previews: PreviewProvider {
    static var previews: some View {
        StartPlanView().environmentObject(UserOB())
    }
}

