//
//  MonthlyPlanningView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/13.
//

import SwiftUI

struct MonthlyPlanningView: View {
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 60)
            subHeader
        }.padding(.horizontal, 14)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private var subHeader: some View {
        HStack {
            Text("월간 이유식").font(.title).bold()
            Text("생후 +180").font(.system(size: 15, weight: .bold))
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .padding(.vertical, 3)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.gray)
                        .opacity(0.3)
                }
            Spacer()
            Text("전체").foregroundColor(.gray)
            Image(systemName: "gearshape")
                .font(.headline)
                .bold()
                .foregroundColor(.gray)
        }
    }
}

struct MonthlyPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyPlanningView()
    }
}
