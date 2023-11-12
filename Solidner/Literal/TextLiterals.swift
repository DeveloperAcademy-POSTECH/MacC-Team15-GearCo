//
//  TextLiterals.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//

import Foundation

enum TextLiterals {

    // MARK: - Weekly Planning
    // 1. enum으로 한 번 더 뺄지, 2. TextLiterals 내에 두되 mark로 구분할지 고민
    // 일단 1의 방식으로 진행했습니다.

    enum WeeklyPlanning {
        static var weeklyPlanningText: String { "주간 이유식" }
        static var chooseIngredientToTestText: String { "테스트 할 재료를 골라주세요." }
        static func solidFoodDayText(from: Int, to: Int) -> String { "\(from)-\(to)일차 >" }
    }

    enum SolidFoodBatchSetting {
        static var labelText: String { "이유식 일괄 설정" }
        static var hintText: String { "전체적으로 변경되는 어쩌구 저쩌구에요." }
        static var testCycleText: String { "테스트 주기" }
        static var deleteAllCalendarsText: String { "캘린더 삭제" }
        static var deleteAllCalendarsButtonText: String { "삭제하기" }
    }
    
    enum Onboarding {
        
    }
}


