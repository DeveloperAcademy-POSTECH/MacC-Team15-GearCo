//
//  DisplayDateType.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import Foundation

enum DisplayDateType: Int, CaseIterable, Hashable, CustomStringConvertible {
    case solid, birth

    var description: String {
        switch self {
        case .solid:
            return TextLiterals.PlanBatchSetting.bySolidDate
        case .birth:
            return TextLiterals.PlanBatchSetting.byBirthDate
        }
    }
}
