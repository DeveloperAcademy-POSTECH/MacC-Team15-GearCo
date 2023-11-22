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
    
    private let nowMonthWeekNums = Date.nowMonthWeeks()
    
    // Dummy struct
    struct planData {
        var startDate: Int
        var endDate: Int
    }
    let plan: [planData] =
    [planData(startDate: 1, endDate: 3),
    planData(startDate: 3, endDate: 5),
    planData(startDate: 5, endDate: 7),
    planData(startDate: 12, endDate: 15)]

    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 70)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    calendarCurrentYearMonth.padding(.bottom, 15)
                    VStack(spacing: 0) {
                        calendarWeekDayRow
                        ForEach(nowMonthWeekNums, id: \.self) { num in
                            calendarDayNumberRow(weekOfMonth: num)
                            calendarNewIngredientRow(weekOfMonth: num)
                        }
                        Spacer()
                    }.background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }.clipped().padding(.horizontal, 16)
            }
        }.background(Color(.lightGray))
    }
    
    private func calendarNewIngredientRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let newIngredientRowHeight = screenWidth * (64/390)
        let ingredientBarHeight = screenWidth * (22/390)
        let rowHorizontalPadding = screenWidth * (4/390)
        
        let gapToFirstBar = screenWidth * (10/390)
        let gapToSecondBar = screenWidth * (5/390)
        
        let barHorizontalPadding = screenWidth * (10/390)
        
        func ingredientBar() -> some View {
            let barWidth = (mainDaySectionWidth*3) - (barHorizontalPadding*2)
            return VStack {
                HStack {
                    Text("\(barHorizontalPadding)")
                        .font(.system(size: 10))
                        .bold()
                        .foregroundColor(.white)
                        .padding(.leading, 7)
                    Spacer()
                }
            }.frame(width: barWidth, height: ingredientBarHeight)
                .background {
                    Rectangle()
                        .leftCornerRadius(4)
                        .foregroundColor(Color.pink.opacity(0.5))
                }.padding(.horizontal, barHorizontalPadding)
        }
        
        return VStack(spacing: 0) {
            Spacer().frame(height: gapToFirstBar)
            HStack(spacing: 0) {
                Spacer().frame(width: rowHorizontalPadding)
                ingredientBar()
                ingredientBar()
                Spacer()
            }.frame(height: ingredientBarHeight)
                .frame(maxWidth: 358)
            Spacer().frame(height: gapToSecondBar)
            HStack(spacing: 0) {
                Spacer().frame(width: rowHorizontalPadding)
                ingredientBar()
                Spacer()
            }.frame(height: ingredientBarHeight)
            Spacer()
        }.frame(height: newIngredientRowHeight)
    }
    
    private func calendarDayNumberRow(weekOfMonth: Int) -> some View {
        let mainDaySectionWidth = screenWidth * (50/390)
        let dayNumberRowFrameHeight = screenWidth * (60/390)
        let dayNumberGap = screenWidth * (6/390)
        let rowHorizontalPadding = screenWidth * (4/390)
        let thisWeekDates: [Date] = Date.weekDates(weekOfMonth)
        
        func rowLeftEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.first! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: rowHorizontalPadding))
            }
        }
        func rowRightEndSpacer() -> some View {
            if weekOfMonth == nowMonthWeekNums.last! {
                return AnyView(Spacer())
            } else {
                return AnyView(Spacer().frame(width: rowHorizontalPadding))
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
        let mainHorizontalPadding = screenWidth * (4/390)
        let mainDaySectionWidth = screenWidth * (50/390)
        let weekDayRowFrameHeight = screenWidth * (25/390)
        
        return VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(weekDayKorList.indices, id: \.self) { i in
                    if i == 0 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                            .padding(.leading, mainHorizontalPadding)
                    } else if i == 6 {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
                            .bold()
                            .frame(width: mainDaySectionWidth)
                            .padding(.trailing, mainHorizontalPadding)
                    } else {
                        Text(weekDayKorList[i])
                            .font(.system(size: 10))
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
