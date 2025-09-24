//
//  StatisticsCardView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI

struct StatisticsCardView: View {
    let title: String
    let count: Int
    let imageName: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("\(count)개")
                .font(.system(size: 23, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
