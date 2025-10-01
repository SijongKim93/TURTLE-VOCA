//
//  MyPageView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    let store: StoreOf<MyPageReducer>
    
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    logoSection
                    statisticsSection
                    listSection
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var logoSection: some View {
        WithPerceptionTracking {
            Image("logoresize")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 90)
                .padding(.top, 10)
        }
    }
    
    private var statisticsSection: some View {
        WithPerceptionTracking {
            let savedWordCount = store.savedWordCount
            let learnedWordCount = store.learnedWordCount
            let gamePlayCount = store.gamePlayCount
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack(spacing: 25) {
                        StatisticsCardView(
                            title: "저장 된 단어",
                            count: savedWordCount,
                            imageName: "savevoca"
                        )
                        
                        StatisticsCardView(
                            title: "외운 단어",
                            count: learnedWordCount,
                            imageName: "memoryvoca"
                        )
                        
                        StatisticsCardView(
                            title: "게임 진행 수",
                            count: gamePlayCount,
                            imageName: "game"
                        )
                    }
                    .padding(20)
                }
                .background(Color(red: 48/255, green: 140/255, blue: 74/255))
                .cornerRadius(16)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
        }
    }
    
    private var listSection: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    MyPageRowView(
                        title: "앱 정보",
                        systemImageName: "info.circle"
                    ) {
                        // 앱 정보 액션
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    MyPageRowView(
                        title: "설정",
                        systemImageName: "gearshape"
                    ) {
                        // 설정 액션
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                    
                    MyPageRowView(
                        title: "도움말",
                        systemImageName: "questionmark.circle"
                    ) {
                        // 도움말 액션
                    }
                }
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(red: 48/255, green: 140/255, blue: 74/255), lineWidth: 1)
                )
                .cornerRadius(16)
                .padding(.horizontal, 10)
                .padding(.top, 10)
            }
        }
    }
}
