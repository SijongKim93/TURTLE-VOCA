//
//  WordRowView.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/23/25.
//

import SwiftUI
import ComposableArchitecture

struct WordRowView: View {
    let store: StoreOf<CalendarReducer>
    let word: WordEntity
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(word.bookCaseName ?? "")
                                .font(.system(size: 15, weight: .light))
                                .foregroundColor(.gray)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text(word.word ?? "")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Text(word.definition ?? "")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Button {
                                store.send(.wordSpeakButtonTapped(word.word ?? ""))
                            } label: {
                                Image(systemName: "speaker.wave.2.fill")
                                    .foregroundColor(Color(ThemeColor.mainColor))
                            }
                            
                            Button {
                                store.send(.wordMemoryStatusToggled(word, !word.memory))
                            } label: {
                                Image(systemName: word.memory ? "checkmark.square" : "square")
                                    .foregroundColor(Color(ThemeColor.mainColor))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(10)
            }
            .frame(height: 100)
            .background(Color(red: 0.9607844949, green: 0.9607841372, blue: 0.9521661401))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(ThemeColor.mainColor), lineWidth: 1)
            )
            .cornerRadius(16)
            .contextMenu {
                Button("삭제", role: .destructive) {
                    store.send(.wordDeleted(word))
                }
            }
        }
    }
}
