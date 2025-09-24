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
    @ObservedObject var word: WordEntity
    
    var body: some View {
        WithPerceptionTracking {
            let wordMemory = word.memory
            
            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(word.bookCaseName ?? "")
                                .font(.system(size: 15, weight: .light))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button {
                                    store.send(.wordSpeakButtonTapped(word.word ?? ""))
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(Color(ThemeColor.mainColor))
                                }
                                
                                Button {
                                    store.send(.wordMemoryStatusToggled(word, !wordMemory))
                                } label: {
                                    Image(systemName: wordMemory ? "checkmark.square" : "square")
                                        .foregroundColor(Color(ThemeColor.mainColor))
                                }
                            }
                        }
                        
                        HStack {
                            Text(word.word ?? "")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text(word.definition ?? "")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                        
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

#Preview {
    WordRowView(
        store: Store(initialState: CalendarReducer.State()) {
            CalendarReducer()
        } withDependencies: {
            $0.coreDataDependency = CoreDataDependency.previewValue
        },
        word: {
            let word = WordEntity()
            word.word = "Apple"
            word.definition = "사과"
            word.bookCaseName = "과일"
            word.memory = false
            word.date = Date()
            word.uuid = UUID().uuidString
            return word
        }()
    )
    .padding()
}
