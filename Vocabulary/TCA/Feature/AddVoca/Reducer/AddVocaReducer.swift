//
//  AddVocaReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/25/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct AddVocaReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    @Dependency(\.networkDependency) var networkDependency
    
    @ObservableState
    struct State {
        var bookCase: BookCase?
        var bookCaseName: String = ""
        var words: [WordEntity] = []
        var filteredWords: [WordEntity] = []
        var searchText: String = ""
        var isFiltering: Bool = false
        var isLoading: Bool = false
        var isShowingInsertVoca: Bool = false
        
        //번역
        var isTranslating: Bool = false
        var translationResult: String = ""
        
        init(bookCase: BookCase? = nil) {
            self.bookCase = bookCase
            self.bookCaseName = bookCase?.name ?? ""
        }
    }
    
    enum Action {
        case onAppear
        case loadWords
        case wordsLoaded([WordEntity])
        case searchTextChanged(String)
        case wordSelected(WordEntity)
        case addWordButtonTapped
        case dismissInsertVoca
        case refreshWords
        case deleteWord(WordEntity)
        case wordDeleted
        case backButtonTapped
        
        case translateText(String)
        case translationReceived([Translation])
        case translationFailed(Error)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadWords)
                
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
                
            case .addWordButtonTapped:
                state.isShowingInsertVoca = true
                return .none
                
            case .dismissInsertVoca:
                state.isShowingInsertVoca = false
                return .send(.refreshWords)
                
            case .refreshWords:
                return .send(.loadWords)
                
            case let .deleteWord(word):
                return .run { send in
                    do {
                        try await coreDataDependency.deleteWord(word)
                        await send(.wordDeleted)
                    } catch {
                        print("단어 삭제 실패")
                    }
                }
                
            case .wordDeleted:
                return .send(.refreshWords)
                
            case .backButtonTapped:
                return .none
                
            case let .translateText(text):
                state.isTranslating = true
                state.translationResult = ""
                return .run { send in
                    do {
                        let translations = try await networkDependency.translateText(text)
                        await send(.translationReceived(translations))
                    } catch {
                        await send(.translationFailed(error))
                    }
                }
                
            case let .translationReceived(translations):
                state.isTranslating = false
                state.translationResult = translations.first?.text ?? ""
                return .none
                
            case .translationFailed:
                state.isTranslating = false
                state.translationResult = "번역 실패"
                return .none
            }
        }
    }
}
