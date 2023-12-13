//
//  TextLiterals.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//

import Foundation

enum TextLiterals {
    static var emptyString: String { "" }

    // MARK: - Weekly Planning
    // 1. enum으로 한 번 더 뺄지, 2. TextLiterals 내에 두되 mark로 구분할지 고민
    // 일단 1의 방식으로 진행했습니다.

    enum StartPlan {
        static var noWorriesJustStartHeaderText: String { "솔리너로\n걱정없는 이유식 계획." }
        static var noWorriesJustStartDetailText: String { "이유식 식단에 어려움을 겪으셨나요?\n지금 바로 시작해보세요" }
        static var goToPlanButtonText: String { "이유식 계획하기" }
        static var selectStartDateModalTitleText: String { "이제, 시작해볼까요?" }
        static var selectStartDateModalHintText: String { "이유식의 첫 계획 시작일을 알려주세요" }
        static func startButtonLabel(from: Date) -> String { "\(from.month)월 \(from.day)일부터 시작할게요" }
    }

    enum PlanList {
        static func yyyymmHeaderText(date: Date) ->  String { "\(date.year)년 \(date.month)월" }
        static func ddDateText(date: Date) -> String { "\(date.day)일" }
        static func dateRangeString(start: Date, end: Date) -> String {
            "\(start.day)일(\(start.weekDayKor)) ~ \(end.day)일(\(end.weekDayKor))"
        }
        static func fromDateToDateText(from: Int, to: Int) -> String { "\(from) ~ \(to)일차" }
        static var addIngredientText: String { "재료 추가" }
        static var solidTotalSettingText: String { "이유식 전체 설정" }
        
    }

    enum PlanGroupDetail {
        static func dateRangeTitle(from: Date, to: Date) -> String { "\(from.formatted(.MMdE_dotWithSpace)) ~ \n\(to.formatted(.MMdE_dotWithSpace)) 식단" }

        static var editPlan: String { "편집" }
        static var editComplete: String { "완료" }

        static func dateRangeString(start: Date, end: Date) -> String {
            "\(start.day)일(\(start.weekDayKor)) ~ \(end.day)일(\(end.weekDayKor))"
        }
        static var existsDuplicatedMeal: String { "중복되는 끼니가 계획되어 있어요." }
        static var addMeal: String { "끼니 추가" }
    }

    enum DailyPlanList {
        static func titleText(_ date: Date) -> String { "\(date.formatted(.MMdE_dotWithSpace)) 식단" }
        static func dateRangeString(start: Date, end: Date) -> String {
            "\(start.day)일(\(start.weekDayKor)) ~ \(end.day)일(\(end.weekDayKor))"
        }
        static func fromDateToDateText(from: Int, to: Int) -> String {
            "\(from) ~ \(to)일차"
        }
        static var addMealPlanText: String {
            "끼니 추가"
        }
    }

    enum MealGroup {
        static var addIngredientText: String { "재료 추가" }
    }

    enum PlanBatchSetting {
        static var labelText: String { "이유식 전체 설정" }
        static var hintText: String { "캘린더의 간격과 날짜 표기를 지정해요" }

        static var testCycleLabel: String { "간격" }
        static func dateText(of number: Int) -> String { "\(number)일" }

        static var displayDateTypeLabel: String { "날짜 표시" }
        static var bySolidDate: String { "이유식 진행일" }
        static var byBirthDate: String { "생후일자" }

        static var deleteAllCalendarsText: String { "전체 일정 삭제" }
        static var deleteAllCalendarsButtonText: String { "삭제" }
        enum Alert {
            static var title: String { "전체 일정 삭제" }
            static var description: String { "전체 이유식 일정을 삭제할까요?" }
            static var leftButtonText: String { "취소" }
            static var rightButtonText: String { "삭제" }
        }
    }

    enum ChangeMonth {
        static func currentYearText(of year: Int) -> String { "\(year)년" }
        static func monthText(of number: Int) -> String { "\(number)월" }
        static var saveButtonText: String { "이 달의 계획 보기" }
    }

    enum Warning {
        static var warningText: String { "식단에 중복되는 계획이 있어요" }
    }

    enum ViewComponents {
        static var placeHolderMessage: String { "최대 10자내로 입력이 가능해요." }
    }
    
    enum NickName {
        static var warningMessage: String { "닉네임은 최대 10자까지 입력이 가능해요." }
        static var placeHolder: String { "최대 10자내로 입력이 가능해요." }
        static var bigUserNameTitle: String { "닉네임을\n입력해주세요" }
        static var bigBabyNameTitle: String { "자녀분의 이름, 혹은\n별명이 따로 있나요?👼" }
    }
    
    enum SoCuteName {
        static var cuteNameMessage: String { "정말 귀여운 이름이네요!" }
        static var cuteNameButtonTitle: String { "생일도 알려줄래요" }
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
        static var smallTitle: String {"솔리너와 함께라면 이유식 척척박사,\n식단 계획부터 재료 정보까지"}
        static var buttonTitle: String {"솔리너 시작하기"}
    }

    enum MealDetail {
        static func viewHeaderTitleText(from: Date, to: Date, isSingle: Bool) -> String {
            if isSingle {
                return "\(from.formatted(.MMdE_dotWithSpace)) 재료"
            } else {
                return "\(from.formatted(.MMdE_dotWithSpace)) ~ \(to.formatted(.MMdE_dotWithSpace)) 재료"
            }
            
        }
        static var viewInAddTitleText: String { "재료 입력" }
        static var viewInAddTitleHintText: String { "알러지 테스트를 위해 따로 입력해주세요" }
        static var viewInEditTitleText: String { "재료 변경" }
        static var newIngredientText: String { "새로운 재료" }
        static var oldIngredientText: String { "먹어본 재료" }
        static func addOrEditIngredientText(isEditMode: Bool) -> String { isEditMode ? "재료 관리" : "재료 추가" }
        static var deleteText: String { "삭제" }
        static var mealTypeText: String { "식단 종류" }
        static var mealTypeHintText: String { "새로운 재료가 추가된 식단은 아침을 권장해요" }
        static var mealCycleText: String { "식단 주기" }
        static var mealCycleHintText: String { "소아과 전문의는 2-3일의 주기를 권장해요" }
        static var startDateText: String { "시작일" }
        static var changeDateText: String { "날짜 변경" }
        static var gapText: String { "간격" }
        static func dateText(_ number: Int) -> String { "\(number)일" }
        private static func dateYyyyMMdd_Dot_Space(_ date: Date) -> String { "\(date.year). \(date.month). \(date.day)." }
        static func fromToDateText(from: Date, to: Date) -> String { "\(dateYyyyMMdd_Dot_Space(from)) ~ \(dateYyyyMMdd_Dot_Space(to))" }
        static func gapDetailText(_ gap: Int) -> String { "총 \(gap)일간 먹어요" }
        static func mealPlanBottomButtonText(isEditMode: Bool) -> String { isEditMode ? "저장" : "일정 추가하기" }
        static var editCompleteText: String { "변경 완료! 캘린더에도 반영되었어요" }
        static var deleteMealPlanTitleText: String { "일정 삭제" }
        static var deleteMealPlanButtonText: String { "삭제" }

        static var changeStartDateText: String { "시작일 변경" }
        static var changeStartDateDetailText: String { "아래 날짜부터 시작할 예정이에요." }
        static var saveButtonText: String { "저장" }
    }

    enum AddedIngredient {
        static var newText: String { "NEW" }
        static func reactionDateText(of date: Date) -> String { "\(date.month)/\(date.day)" }
        static func canEatText(month: Int) -> String { "\(month)개월 +" }
        static var deleteText: String { "삭제" }
    }

    enum AgreeToTerms {
        static var bigTitle: String { "서비스 이용약관에\n동의해주세요" }
        static var smallTitle: String { "솔리너의 원활한 사용을 위해\n아래의 정보 제공에 동의해주세요." }
        static var serviceUseTitle: String { "[필수] 서비스 이용 약관" }
        static var personalInfoTitle: String { "[필수] 개인정보 수집 및 이용 동의" }
        static var advertisingTitle: String { "[선택] 광고성 정보 수신 동의" }
    }
    
    enum TermsWeb {
        static var serviceUseUrl: String { "https://flaxen-headline-80b.notion.site/Solidner-db0e9f2efed2414aa50a53a9438d99dc?pvs=4" }
        static var personalInfoUrl: String { "https://flaxen-headline-80b.notion.site/Solidner-cf1b28d08a794dffbcc824bcb8391932?pvs=4" }
        static var advertisingURL: String {
            "https://flaxen-headline-80b.notion.site/Solidner-5484d23677674cc686f8e7f197ef729e?pvs=4"
        }
    }
    
    enum AddIngredientsView {
        static func testViewTitle(viewType: MealOB.IngredientTestType) -> String {
            if viewType == .new { "새로운 재료 추가" }
            else { "먹어본 재료 추가" }
        }
        static var 먹을수있는재료Explain: String { "아이가 섭취할 수 있는 재료의\n전체 목록이에요" }
        static var 권장하지않는재료Explain: String { "월령과 이유식 단계에\n권장하지 않는 식재료예요"}
        static var isIngredientNotExist: String { "찾는 재료가 없으신가요?" }
    }
}


