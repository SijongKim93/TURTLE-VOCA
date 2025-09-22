//
//  CalendarReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/18/25.
//

import ComposableArchitecture
import SwiftUI
import Foundation
import AVFoundation

// MARK: - CalendarFeature
@Reducer
struct CalendarReducer {
    // MARK: - Dependencies
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var selectedDate: DateComponents?
        var filteredWords: [WordEntity] = []
        var isCalendarExpanded: Bool = true
        var currentFilterIndex: Int = 0
        var isShowingFilterModal: Bool = false
        var isShowingMenuModal: Bool = false
        var isEmpty: Bool { filteredWords.isEmpty }
        
        init() {
            let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            self.selectedDate = currentDate
        }
    }
    
    // MARK: - Action
    enum Action {
        case dateSelected(DateComponents?)
        case calendarToggleExpanded
        case loadDecorations
        
        // 데이터 관련
        case fetchWordsForSelectedDate
        case wordsLoaded([WordEntity])
        case wordMemoryStatusToggled(WordEntity, Bool)
        case wordDeleted(WordEntity)
        
        // 필터 관련
        case filterButtonTapped
        case filterChanged(Int)
        case filterModalDismissed
        
        // 메뉴 관련
        case menuButtonTapped
        case markAllWordsAsLearned
        case deleteAllWords
        case menuModalDismissed
        
        // UI 관련
        case upButtonTapped
        case wordSpeakButtonTapped(String)
        
        // 필터 저장/로드
        case loadFilterIndex
        case saveFilterIndex(Int)
        
        // 내부 액션
        case _wordMemoryUpdateResult(Result<Void, Error>)
        case _wordDeleteResult(Result<Void, Error>)
        case _markAllWordsResult(Result<Void, Error>)
        case _deleteAllWordsResult(Result<Void, Error>)
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            
            // MARK: - 캘린더 액션
            case let .dateSelected(dateComponents):
                state.selectedDate = dateComponents
                return .send(.fetchWordsForSelectedDate)
                
            case .calendarToggleExpanded:
                state.isCalendarExpanded.toggle()
                return .none
                
            case .loadDecorations:
                return .none
                
            // MARK: - 데이터 관련 액션
            case .fetchWordsForSelectedDate:
                guard let selectedDate = state.selectedDate,
                      let date = Calendar.current.date(from: selectedDate) else {
                    return .none
                }
                
                return .run { send in
                    do {
                        let words = try await coreDataDependency.getWordFromCoreData(date)
                        await send(.wordsLoaded(words))
                    } catch {
                        await send(.wordsLoaded([]))
                    }
                }
                
            case let .wordsLoaded(words):
                // 필터 적용
                state.filteredWords = filterWords(words, by: state.currentFilterIndex)
                return .none
                
            case let .wordMemoryStatusToggled(word, newStatus):
                return .run { send in
                    await send(._wordMemoryUpdateResult(
                        Result {
                            try await coreDataDependency.updateWordMemoryStatus(word, newStatus)
                        }
                    ))
                }
                
            case let .wordDeleted(word):
                return .run { send in
                    await send(._wordDeleteResult(
                        Result {
                            try await coreDataDependency.deleteWord(word)
                        }
                    ))
                }
                
            // MARK: - 필터 관련 액션
            case .filterButtonTapped:
                state.isShowingFilterModal = true
                return .none
                
            case let .filterChanged(newFilterIndex):
                state.currentFilterIndex = newFilterIndex
                // 기존 단어들에 새 필터 적용
                let allWords = state.filteredWords
                state.filteredWords = filterWords(allWords, by: newFilterIndex)
                return .none
                
            case .filterModalDismissed:
                state.isShowingFilterModal = false
                return .send(.fetchWordsForSelectedDate)
                
            // MARK: - 메뉴 관련 액션
            case .menuButtonTapped:
                state.isShowingMenuModal = true
                return .none
                
            case .markAllWordsAsLearned:
                guard let selectedDate = state.selectedDate,
                      let date = Calendar.current.date(from: selectedDate) else {
                    return .none
                }
                
                return .run { send in
                    await send(._markAllWordsResult(
                        Result {
                            try await coreDataDependency.markAllWordsAsLearned(date)
                        }
                    ))
                }
                
            case .deleteAllWords:
                guard let selectedDate = state.selectedDate,
                      let date = Calendar.current.date(from: selectedDate) else {
                    return .none
                }
                
                return .run { send in
                    await send(._deleteAllWordsResult(
                        Result {
                            try await coreDataDependency.deleteAllWords(date)
                        }
                    ))
                }
                
            case .menuModalDismissed:
                state.isShowingMenuModal = false
                return .none
                
            // MARK: - UI 액션
            case .upButtonTapped:
                state.isCalendarExpanded.toggle()
                return .none
                
            case let .wordSpeakButtonTapped(text):
                return .run { send in
                    await MainActor.run {
                        let synthesizer = AVSpeechSynthesizer()
                        let utterance = AVSpeechUtterance(string: text)
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        utterance.rate = 0.5
                        synthesizer.speak(utterance)
                    }
                }
                
            // MARK: - 필터 관련 액션
            case .loadFilterIndex:
                return .run { send in
                    let filterIndex = await MainActor.run {
                        if UserDefaults.standard.object(forKey: "SelectedFilterIndex") == nil {
                            UserDefaults.standard.set(0, forKey: "SelectedFilterIndex")
                            UserDefaults.standard.synchronize()
                        }
                        return UserDefaults.standard.integer(forKey: "SelectedFilterIndex")
                    }
                    await send(.filterChanged(filterIndex))
                }
                
            case let .saveFilterIndex(index):
                return .run { send in
                    await MainActor.run {
                        UserDefaults.standard.set(index, forKey: "SelectedFilterIndex")
                        UserDefaults.standard.synchronize()
                    }
                }
                
            // MARK: - 내부 결과 액션
            case ._wordMemoryUpdateResult(.success):
                return .send(.fetchWordsForSelectedDate)
                
            case ._wordMemoryUpdateResult(.failure):
                // TODO: 에러 알림 처리
                return .none
                
            case ._wordDeleteResult(.success):
                return .concatenate(
                    .send(.fetchWordsForSelectedDate),
                    .send(.loadDecorations)
                )
                
            case ._wordDeleteResult(.failure):
                // TODO: 에러 알림 처리
                return .none
                
            case ._markAllWordsResult(.success):
                return .send(.fetchWordsForSelectedDate)
                
            case ._markAllWordsResult(.failure):
                // TODO: 에러 알림 처리
                return .none
                
            case ._deleteAllWordsResult(.success):
                return .concatenate(
                    .send(.fetchWordsForSelectedDate),
                    .send(.loadDecorations)
                )
                
            case ._deleteAllWordsResult(.failure):
                return .none
            }
        }
    }
}

// MARK: - Helper Functions
extension CalendarReducer {
    private func filterWords(_ words: [WordEntity], by filterIndex: Int) -> [WordEntity] {
        switch filterIndex {
        case 0:
            return words
        case 1:
            return words.filter { !$0.memory }
        case 2:
            return words.filter { $0.memory }
        default:
            return words
        }
    }
}
