//
//  FoodStageSelectView.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/13.
//

import SwiftUI

struct FoodStageSelectView: View {
    let guidingBubbleColor = Color(#colorLiteral(red: 0.7149112821, green: 0.7669619918, blue: 0.6710264087, alpha: 1))
    let dividerBubbleColor = Color(#colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)).opacity(0.2)
    let downChevronColor = Color(#colorLiteral(red: 0.7176470588, green: 0.7176470588, blue: 0.7176470588, alpha: 1))
    let foodStagePickerColor = Color(#colorLiteral(red: 0.5019607843, green: 0.5568627451, blue: 0.6745098039, alpha: 1)).opacity(0.1)
    @State var dayNumber = 0.0
    var body: some View {
        VStack(spacing: 0) {
            BackButtonHeader()
            OnboardingTitles(bigTitle: "아이의 이유식 단계를\n확인해주세요!", smallTitle: "아이의 월령에 따라\n자동으로 단계를 입력했어요.")
            HStack(alignment: .bottom, spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Text("초기 전반 과정중 10일차에요")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(guidingBubbleColor)
                    .cornerRadius(12)
                    .padding(.bottom, 5)
                }
                Circle()
                    .fill(guidingBubbleColor)
                    .frame(width: 10, height: 10)
                    .padding(.leading, 8)
            }
            .padding(.top, 50)
            Rectangle()
                .fill(dividerBubbleColor)
                .frame(maxWidth: .infinity)
                .frame(height: 10)
                .padding(.top, 20)
            VStack(spacing: 0) {
                HStack {
                    Text("이유식 단계")
                        .font(.system(size: 19, weight: .semibold))
                    Spacer()
                }
                HStack {
                    Text("초기 전반 (6개월 전반)")
                        .font(.system(size: 15, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(downChevronColor)
                }
                .padding(18)
                .background(foodStagePickerColor)
                .cornerRadius(12)
                .padding(.top, 16)
                HStack {
                    Text("일차 수")
                        .font(.system(size: 19, weight: .semibold))
                    Spacer()
                }
            }
            
        }
    }
}

struct FoodStageSelectView_Previews: PreviewProvider {
    static var previews: some View {
        FoodStageSelectView()
    }
}
