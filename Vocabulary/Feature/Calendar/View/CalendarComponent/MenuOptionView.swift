//
//  MenuOptionView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/22/25.
//

import SwiftUI
import ComposableArchitecture

struct MenuView: View {
    let store: StoreOf<CalendarReducer>
    
    private let menuOptions = ["다 외웠어요", "전체 삭제"]
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    Text("단어 상태 설정")
                        .font(.system(size: 23, weight: .bold))
                    
                    Spacer()
                    
                    Button {
                        store.send(.menuModalDismissed)
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 15)
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
                    .padding(.top, 15)
                
                VStack(spacing: 0) {
                    ForEach(0..<menuOptions.count, id: \.self) { index in
                        MenuOptionRow(
                            title: menuOptions[index],
                            isDestructive: index == 1,
                            onTap: {
                                if index == 0 {
                                    store.send(.markAllWordsAsLearned)
                                } else {
                                    store.send(.deleteAllWords)
                                }
                                store.send(.menuModalDismissed)
                            }
                        )
                        
                        if index < menuOptions.count - 1 {
                            Divider()
                                .padding(.horizontal, 10)
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}

struct MenuOptionRow: View {
    let title: String
    let isDestructive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Spacer()
                
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(isDestructive ? .red : .black)
                
                Spacer()
            }
            .padding(.vertical, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
