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
    
    enum NickName {
        static var warningMessage: String { "닉네임은 최대 10자까지 입력이 가능해요." }
        static var placeHolder: String { "최대 10자내로 입력이 가능해요." }
        static var bigTitle: String { "닉네임을\n입력해주세요" }
    }
    
    enum SoCuteName {
        static var cuteNameMessage: String { "정말 귀여운 이름이네요!" }
    }
    
    enum BabyBirthDate {
        static var cakeLabelText: String { "🎂" }
        static var bigTitle: String { "의 생일" }
        static var smallTitle: String {"아기의 생년월일을 입력해주세요."}
    }
    
    enum FoodStartDate {
        static var bigTitle: String { "언제부터 이유식을\n계획할까요?" }
        static var smallTitle: String {"이미 이유식을 진행 중이라면\n처음 시작하신 날짜를 알려주세요"}
    }
    
    enum OnboardingEnd {
        static var bigTitle: String { "가장 쉬운\n이유식의 첫 시작" }
        static var smallTitle: String {"이유식 플래닝을 함께 고고씽\n어쩌구저쩌구"}
        static var buttonTitle: String {"솔리너 시작하기"}
    }
    
}


