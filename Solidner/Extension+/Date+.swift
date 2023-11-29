//
//  Date+.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import Foundation

extension Date {
    /// 연, 월, 일을 parameter로 받아, Date 객체로 반환합니다.
    /// 잘못된 날짜를 입력하여 실패할 경우, nil을 반환합니다.
    /// - Parameters:
    ///   - year: 연도. Int형
    ///   - month: 월. Int형
    ///   - day: 일. Int형
    /// - Returns: 해당 연,월,일을 기반으로 한 Date 객체 (Optional)
    static func date(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return Calendar.current.date(from: dateComponents)
    }
    
    
    /// 두 Date 객체의 시간차를 DateComponents 객체로 반환합니다.
    /// - Parameters:
    ///   - startDate: 시작 시간. Date형
    ///   - endDate: 끝 시간. Date형
    /// - Returns: 시간차를 기록한 DateComponents
    static func componentsBetweenDates(from startDate: Date, to endDate: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)
    }
    
    /// 두 Date 객체를 포함한, 그 사이의 Date들의 리스트를 반환합니다.
    /// - Parameters:
    ///   - startDate: 시작일. (Date)
    ///   - endDate: 종료일. (Date)
    /// - Returns: 시작일과 종료일 사이의 날짜의 Date 객체를 갖는 리스트.
    static func range(from startDate: Date, to endDate: Date) -> [Date] {
        let diff = componentsBetweenDates(from: startDate, to: endDate).day!
        return (0...diff).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: startDate)
        }
    }
    
    /// 현재 날짜가 포함된 달의 모든 날짜의 Date 객체들을 반환합니다.
    /// - Returns: 현재 달의 모든 날짜의 Date 객체를 포함한 리스트.
    static func nowMonthDates() -> [Date] {
        let now = Date()
        let range = Calendar.current.range(of: .day, in: .month, for: now) ?? Range<Int>(1...1)
        
        let nowMonthFirstDay = Date.date(year: now.year, month: now.month, day: 1) ?? now
        let nowMonthLastDay = Date.date(year: now.year, month: now.month, day: range.upperBound - 1) ?? now
        let resultDates = Date.range(from: nowMonthFirstDay, to: nowMonthLastDay)
        
        if resultDates.count <= 1 {
            fatalError("시간 설정 오류. 기기의 시간을 확인해주세요.")
        } else {
            return resultDates
        }
    }
    
    /// 현재 날짜가 포함된 달이 몇 주차 까지 있는지 계산하여 Int형 리스트로 반환합니다.
    /// - Returns: 현재 달의 주차를 Int형 리스트로 반환 (ex. `[1, 2, 3, 4, 5]`)
    static func nowMonthWeeks() -> [Int] {
        let now = Date()
        let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: now) ?? Range<Int>(1...1)
        
        if range.upperBound == 1 {
            fatalError("시간 설정 오류. 기기의 시간을 확인해주세요.")
        } else {
            return Array(range.lowerBound...range.upperBound - 1)
        }
    }
    
    
    /// 현재 주차에 포함된 Date 객체들을 리스트로 반환합니다.
    /// - Returns: 현재 주차의 날들을 Date형 리스트로 반환
    static func nowWeekDates() -> [Date] {
        let nowWeekOfMonth = Date().weekOfMonth
        let nowMonthDates = Date.nowMonthDates()
        
        return nowMonthDates.filter { $0.weekOfMonth == nowWeekOfMonth }
    }
    
    
    /// 파라미터로 받은 주차에 포함된 Date 객체를 리스트로 반환합니다.
    /// - Parameter weekOfMonth: 원하는 주차 (Int)
    /// - Returns: 입력된 주차에 포함된 날들을 Date형 리스트로 반환
    static func weekDates(_ weekOfMonth: Int) -> [Date] {
        let nowMonthDates = Date.nowMonthDates()
        
        return nowMonthDates.filter { $0.weekOfMonth == weekOfMonth }
    }

    
    /// component를 value만큼 더한 Date를 반환합니다.
    /// self.add(.day, value: 1) -> self에 1 day를 더한 Date
    /// - Parameters:
    ///   - component: Calendar.Component. 예를 들면 .year, .month, .day
    ///   - value: 원하는 값
    /// - Returns: component를 value만큼 더한 Date
    func add(_ component: Calendar.Component, value: Int) -> Date {
        Calendar.current.date(byAdding: component, value: value, to: self)!
    }
    
    /// - Returns: Array of `self` 날짜가 포함된 달의 모든 날짜의 Date
    func monthDates() -> [Date] {
        let nowMonthFirstDay = Date.date(year: year, month: month, day: 1) ?? self
        let nowMonthLastDay = Date.date(year: year, month: month + 1, day: 1)?.add(.day, value: -1) ?? self
        
        let resultDates = Date.range(from: nowMonthFirstDay, to: nowMonthLastDay)
        
        if resultDates.count <= 1 {
            fatalError("시간 설정 오류. 기기의 시간을 확인해주세요.")
        } else {
            return resultDates
        }
    }
    

    /// 아래의 day부터 weekDayOrdinal까지는
    /// Calendar 객체의 데이터를 Date의 Extension으로 포함시켜 Date 객체에서 바로 사용할 수 있게 합니다.
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var weekDayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }
    
    /// weekDay의 한글 표현을 반환합니다.
    /// weekday는 1~7 사이의 Int형 정수입니다. (1 - 일요일, 2 - 월요일..)
    /// Ex. 일, 월, 화, 수, 목, 금, 토
    var weekDayKor: String {
        Weekday(rawValue: weekday)!.description
    }
    
    /// `formatted(_ format: DateFormat) -> String` 함수에 사용되는 format 형식을 case로 재정의한 enum입니다.
    enum DateFormat: String {
        case yyyyMMdd_dot = "yyyy.MM.dd"
        case yyyyMMdd_dotWithSpace = "yyyy. MM. dd"
        case yyyyMMdd_fullKorean = "yyyy년 MM월 dd일"
        // 11/13
        case MMdd_slash = "MM/dd"
    }

    func isInBetween(from: Date, to: Date) -> Bool {
        self >= from && self <= to
    }

    /// 이 Extension 내에서 정의한 DateFormat Enum 참고.
    /// DateFormat 형식에 따라 Date를 가공하여 문자열 형식으로 반환합니다.
    /// - Parameter format: DateFormat Enum의 case.
    /// - Returns: 현재 날짜의 포맷된 형태의 문자열
    func formatted(_ format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    /// Weekday의 한글 표현을 description으로 관리하기 위해 정의한 enum입니다.
    enum Weekday: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7

        var description: String {
            switch self {
            case .sunday:
                return "일"
            case .monday:
                return "월"
            case .tuesday:
                return "화"
            case .wednesday:
                return "수"
            case .thursday:
                return "목"
            case .friday:
                return "금"
            case .saturday:
                return "토"
            }
        }
    }
}

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
