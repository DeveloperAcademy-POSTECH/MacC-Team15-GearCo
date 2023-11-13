//
//  MonthlyPlanningView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/13.
//

import SwiftUI

struct MonthlyPlanningView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    let lightGray = Color(#colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)) // #D9D9D9
    let weekDayKorList = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 70)
            calendarCurrentYearMonth.padding(.bottom, 15)
            
            VStack(spacing: 0) {
                calendarWeekDayRow
                Spacer()
            }.background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            }
            Spacer()
        }.padding(.horizontal, 14)
            .background(Color(.lightGray))
    }
    
    private var calendarWeekDayRow: some View {
        let mainHorizontalPadding = screenWidth * (6/390)
        let mainDaySectionWidth = screenWidth * (50/390)
        
        return HStack(alignment: .center, spacing: 0) {
            ForEach(weekDayKorList.indices) { i in
                if i == 0 {
                    Text(weekDayKorList[i])
                        .frame(width: mainDaySectionWidth)
                        .padding(.leading, mainHorizontalPadding)
                } else if i == 6 {
                    Text(weekDayKorList[i])
                        .frame(width: mainDaySectionWidth)
                        .padding(.trailing, mainHorizontalPadding)
                } else {
                    Text(weekDayKorList[i])
                        .frame(width: mainDaySectionWidth)
                }
            }
        }.frame(height: 25)
    }
    
    private var calendarCurrentYearMonth: some View {
        HStack {
            Text("2023년 10월").font(.title).bold()
            Spacer()
        }
    }
}

struct MonthlyPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPlanningView()
    }
}
