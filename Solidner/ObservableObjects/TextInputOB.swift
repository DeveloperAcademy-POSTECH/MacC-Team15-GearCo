//
//  TextInputOB.swift
//  Solidner
//
//  Created by 황지우2 on 12/2/23.
//

import SwiftUI

final class TextInputOB: ObservableObject {
    private let limit = 10
    @Published var value = "" {
        didSet {
            if value.count > self.limit {
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}
