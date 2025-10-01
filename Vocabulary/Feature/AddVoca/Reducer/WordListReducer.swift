//
//  WordListReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/27/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct WordListReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State: Equatable {
        var words: [WordEntity] = []
        var filteredWords: [WordEntity] = []
        var searchText: String = ""
        var isFiltering: Bool = false
        var isLoading: Bool = false
        var bookCase: BookCase?
        
        init(bookCase: BookCase? = nil) {
            self.bookCase = bookCase
        }
    }
    
    enum Action: Equatable {
        case loadWords
        case wordsLoaded([WordEntity])
        case searchTextChanged(String)
        case wordSelected(WordEntity)
        case deleteWord(WordEntity)
        case wordDeleted
        case refreshWords
        case setBookCase(BookCase?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadWords:
                state.isLoading = true
                return .run { [bookCase = state.bookCase] send in
                    do {
                        let words = try await coreDataDependency.getWordsFromBookCase(bookCase)
                        await send(.wordsLoaded(words))
                    } catch {
                        await send(.wordsLoaded([]))
                    }
                }
                
            case let .wordsLoaded(words):
                state.words = words
                state.filteredWords = words
                state.isLoading = false
                return .none
                
            case let .searchTextChanged(text):
                state.searchText = text
                state.isFiltering = !text.isEmpty
                
                if text.isEmpty {
                    state.filteredWords = state.words
                } else {
                    state.filteredWords = state.words.filter { word in
                        (word.word?.localizedCaseInsensitiveContains(text) ?? false) ||
                        (word.definition?.localizedCaseInsensitiveContains(text) ?? false)
                    }
                }
                return .none
                
            case .wordSelected:
                return .none
                
            case let .deleteWord(word):
                return .run { send in
                    do {
                        try await coreDataDependency.deleteWord(word)
                        await send(.wordDeleted)
                    } catch {
                        print("단어 삭제 실패: \(error)")
                    }
                }
                
            case .wordDeleted:
                return .send(.refreshWords)
                
            case .refreshWords:
                return .send(.loadWords)
                
            case let .setBookCase(bookCase):
                state.bookCase = bookCase
                return .send(.loadWords)
            }
        }
    }
}

