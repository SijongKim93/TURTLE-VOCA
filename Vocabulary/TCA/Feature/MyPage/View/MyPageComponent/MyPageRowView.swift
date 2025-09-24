//
//  MyPageRowView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/23/25.
//

import SwiftUI

struct MyPageRowView: View {
    let title: String
    let systemImageName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: systemImageName)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 48/255, green: 140/255, blue: 74/255))
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.white)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(height: 80)
    }
}
