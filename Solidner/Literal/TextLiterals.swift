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
    
    enum ViewComponents {
        static var placeHolderMessage: String { "최대 10자내로  입력이 가능해요." }
    }
    
    enum NickName {
        static var warningMessage: String { "닉네임은 최대 10자까지 입력이 가능해요." }
        static var placeHolder: String { "최대 10자내로 입력이 가능해요." }
        static var bigUserNameTitle: String { "닉네임을\n입력해주세요" }
        static var bigBabyNameTitle: String { "자녀분의 이름, 혹은\n별명이 따로 있나요? 🤶" }
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

    enum MealDetail {
        static var insertIngredientText: String { "재료 입력" }
        static var insertIngredientHintText: String { "알러지 테스트를 위해 따로 입력해주세요." }
        static var ingredientsDetailTitleText: String { "재료 디테일티비" }
        static var newIngredientText: String { "처음 먹는 재료" }
        static var testedIngredientText: String { "테스트 해본 재료" }
        static func addOrEditIngredientText(isEditMode: Bool) -> String { isEditMode ? "재료 관리" : "재료 추가" }
        static var deleteText: String { "삭제" }
        static var mealTypeText: String { "식단 종류" }
        static var mealTypeHintText: String { "새로운 재료가 추가된 식단은 아침을 권장해요." }
        static var mealCycleText: String { "식단 주기" }
        static var mealCycleHintText: String { "소아과 전문의는 2-3일의 주기를 권장해요." }
        static var startDateText: String { "시작일" }
        static var changeDateText: String { "날짜 변경" }
        static var gapText: String { "간격" }
        static func dateText(_ number: Int) -> String { "\(number)일" }
        static func fromStartDate(_ startDate: Date) -> String { "\(startDate.formatted(.yyyyMMdd_dot)) ~ " }
        static func gapDetailText(_ gap: Int) -> String { "총 \(gap)일간 먹어요." }
        static var addMealPlanButtonText: String { "일정 추가하기" }
        static var deleteMealPlanTitleText: String { "끼니 삭제" }
        static var deleteMealPlanButtonText: String { "삭제하기" }
    }
    
    enum AgreeToTermsView { 
        static var bigTitle: String { "서비스 이용약관에\n동의해주세요" }
        static var smallTitle: String { "솔리너의 원활한 사용을 위해\n아래의 정보 제공에 동의해주세요." }
        static var serviceUseTitle: String { "[필수] 서비스 이용 약관" }
        static var personalInfoTitle: String { "[필수] 개인정보 수집 및 이용 동의" }
        static var advertisingTitle: String { "[선택] 광고성 정보 수신 동의" }
    }
    
    enum AddIngredientsView {
        static var testViewTitle: String { "테스트 재료 추가" }
    }
}


