//
//  MonthlyPlanningView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/13.
//

import SwiftUI

struct MonthlyPlanningView: View {
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    private let lightGray = Color(#colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)) // #D9D9D9
    private let weekDayKorList = ["일", "월", "화", "수", "목", "금", "토"]
    
    private let nowMonthDates = Date.nowMonthDates()
    private let nowMonthWeekNums = Date.nowMonthWeeks()
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 70)
            calendarCurrentYearMonth.padding(.bottom, 15)
            
            VStack(spacing: 0) {
                calendarWeekDayRow
                ForEach(nowMonthWeekNums, id: \.self) { num in
                    calendarDayNumberRow(weekOfMonth: num)
                }
                Text("\(nowMonthWeekNums.last!.description)")
                Spacer()
            }.background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
            }
            Spacer()
        }.padding(.horizontal, 14)
            .background(Color(.lightGray))
    }
    
    private func calendarDayNumberRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let dayNumberRowFrameHeight = screenWidth * (60/390)
        let dayNumberGap = screenWidth * (6/390)
        let rowHorizontalPadding = screenWidth * (6/390)
        let thisWeekDates: [Date] = Date.weekDates(weekOfMonth)
        
        func rowLeftEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.first! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: 6))
            }
        }
        func rowRightEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.last! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: 6))
            }
        }
        
        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                rowLeftEndSpacer()
                ForEach(thisWeekDates, id: \.self) { date in
                    VStack(spacing: 0) {
                        Text("\(date.day)")
                            .font(.system(size: 11))
                            .padding(.bottom, dayNumberGap)
                        Text("\(date.day)")
                            .font(.system(size: 17))
                    }.frame(width: mainDaySectionWidth)
                }
                rowRightEndSpacer()
            }.frame(height: dayNumberRowFrameHeight)
            calendarDivider
        }
    }
    
    private var calendarWeekDayRow: some View {
        // TODO: color 및 font 수정
        let mainHorizontalPadding = screenWidth * (6/390)
        let mainDaySectionWidth = screenWidth * (50/390)
        let weekDayRowFrameHeight = screenWidth * (25/390)
        
        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(weekDayKorList.indices, id: \.self) { i in
                    if i == 0 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 12))
                            .bold()
                            .frame(width: mainDaySectionWidth)
//                            .padding(.leading, mainHorizontalPadding)
                    } else if i == 6 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 12))
                            .bold()
                            .frame(width: mainDaySectionWidth)
//                            .padding(.trailing, mainHorizontalPadding)
                    } else {
                        Text(weekDayKorList[i])
                            .font(.system(size: 12))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                    }
                }
            }.frame(height: weekDayRowFrameHeight)
            calendarDivider
        }
    }
    
    private var calendarDivider: some View {
        Rectangle().frame(height: 1).foregroundColor(.black)
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
