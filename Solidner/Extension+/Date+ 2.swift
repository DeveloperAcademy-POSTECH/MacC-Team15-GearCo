//
//  Date+.swift
//  Solidner
//
//  Created by sei on 11/13/23.
//

import Foundation

extension Date {
    static func date(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        return Calendar.current.date(from: dateComponents)
    }

    static func componentsBetweenDates(from startDate: Date, to endDate: Date) -> DateComponents {
        Calendar.current.dateComponents([.day, .hour, .minute], from: startDate, to: endDate)
    }

    static func range(from startDate: Date, to endDate: Date) -> [Date] {
        let diff = componentsBetweenDates(from: startDate, to: endDate).day!
        return (0...diff).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: startDate)
        }
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var weekDayKor: String {
        Weekday(rawValue: weekday)!.description
    }

    enum DateFormat: String {
        case yyyyMMdd_dot = "yyyy.MM.dd"
        // 11/13
        case MMdd_slash = "MM/dd"
    }

    func formatted(_ format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

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
