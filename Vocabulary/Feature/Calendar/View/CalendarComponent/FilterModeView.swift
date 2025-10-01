//
//  FilterModeView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/22/25.
//

import SwiftUI
import ComposableArchitecture

struct FilterModeView: View {
    let store: StoreOf<CalendarReducer>
    
    private let filterOptions = ["최근 저장 순", "오래된 저장 순", "외운 단어 순", "못 외운 단어순", "랜덤"]
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    Text("단어 정렬 설정")
                        .font(.system(size: 23, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    Button {
                        store.send(.filterModalDismissed)
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
                    ForEach(0..<filterOptions.count, id: \.self) { index in
                        WithPerceptionTracking {
                            FilterOptionRow(
                                title: filterOptions[index],
                                isSelected: store.currentFilterIndex == index,
                                onTap: {
                                    store.send(.filterChanged(index))
                                    store.send(.saveFilterIndex(index))
                                }
                            )
                        }
                        
                        if index < filterOptions.count - 1 {
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

struct FilterOptionRow: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: isSelected ? "circle.circle" : "circle")
                    .foregroundColor(.black)
                    .frame(width:30, height: 30)
            }
            .padding(.vertical, 15)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
