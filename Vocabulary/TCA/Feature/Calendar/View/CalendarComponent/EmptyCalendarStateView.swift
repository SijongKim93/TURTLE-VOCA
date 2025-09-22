//
//  EmptyStateView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/22/25.
//

import SwiftUI

struct EmptyCalendarStateView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image("turtle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            Text("저장된 단어가 없습니다.")
                .font(.system(size: 18))
                .foregroundColor(Color(ThemeColor.mainColor))
                .multilineTextAlignment(.center)
        }
    }
}
