//
//  MonthlyPlanningView.swift
//  Solidner
//
//  Created by 이재원 on 2023/11/13.
//

import SwiftUI

struct MonthlyPlanningView: View {
    let lightGray = Color(#colorLiteral(red: 0.8797428608, green: 0.8797428012, blue: 0.8797428608, alpha: 1)) // #D9D9D9
    
    let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 임시로 대충 헤더 자리 비워두기
            Spacer().frame(height: 70)
            subHeader
            Spacer()
        }.padding(.horizontal, 14)
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
                        .foregroundColor(lightGray)
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
