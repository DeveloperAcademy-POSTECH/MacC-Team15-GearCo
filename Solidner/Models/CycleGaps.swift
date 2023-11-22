//
//  CycleGaps.swift
//  Solidner
//
//  Created by sei on 11/22/23.
//

import Foundation

enum CycleGaps: Int, Hashable, CustomStringConvertible, CaseIterable {
    case one = 1, two, three, four
    var description: String {
        "\(self.rawValue)일"
    }
}

