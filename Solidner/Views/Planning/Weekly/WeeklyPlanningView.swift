//
//  WeeklyPlanningView.swift
//  Solidner
//
//  Created by sei on 11/9/23.
//

import SwiftUI

struct WeeklyPlanningView: View {
    var body: some View {
        ScrollView {
            VStack {
                title
            }
        }
    }

    var title: some View {
        Text("주간 이유식")
    }
}

#Preview {
    WeeklyPlanningView()
}
