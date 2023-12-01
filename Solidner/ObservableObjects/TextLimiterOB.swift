//
//  TextLimiterOB.swift
//  Solidner
//
//  Created by 황지우2 on 2023/11/12.
//

import SwiftUI

final class TextLimiterOB: ObservableObject {
    private let limit = 10
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}
