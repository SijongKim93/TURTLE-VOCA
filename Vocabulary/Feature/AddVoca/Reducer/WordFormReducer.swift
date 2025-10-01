//
//  WordFormReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct WordFormReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State: Equatable {
        var wordInput: String = ""
        var definitionInput: String = ""
        var detailInput: String = ""
        var pronunciationInput: String = ""
        var synonymInput: String = ""
        var antonymInput: String = ""
        
        var isEditing: Bool = false
        var existingWord: WordEntity?
        var bookCase: BookCase?
        var bookCaseName: String = ""
        
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(bookCase: BookCase? = nil, existingWord: WordEntity? = nil) {
            self.bookCase = bookCase
            self.bookCaseName = bookCase?.name ?? ""
            self.existingWord = existingWord
            self.isEditing = existingWord != nil
            
            if let word = existingWord {
                self.wordInput = word.word ?? ""
                self.definitionInput = word.definition ?? ""
                self.detailInput = word.detail ?? ""
                self.pronunciationInput = word.pronunciation ?? ""
                self.synonymInput = word.synonym ?? ""
                self.antonymInput = word.antonym ?? ""
            }
        }
    }
    
    enum Action: Equatable {
        case wordInputChanged(String)
        case definitionInputChanged(String)
        case detailInputChanged(String)
        case pronunciationInputChanged(String)
        case synonymInputChanged(String)
        case antonymInputChanged(String)
        case translationSelected(String)
        case saveWord
        case wordSaved
        case saveWordFailed(String)
        case resetForm
        case setBookCase(BookCase?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .wordInputChanged(text):
                state.wordInput = text
                return .none
                
            case let .definitionInputChanged(text):
                state.definitionInput = text
                return .none
                
            case let .detailInputChanged(text):
                state.detailInput = text
                return .none
                
            case let .pronunciationInputChanged(text):
                state.pronunciationInput = text
                return .none
                
            case let .synonymInputChanged(text):
                state.synonymInput = text
                return .none
                
            case let .antonymInputChanged(text):
                state.antonymInput = text
                return .none
                
            case let .translationSelected(text):
                state.definitionInput = text
                return .none
                
            case .saveWord:
                guard !state.wordInput.isEmpty && !state.definitionInput.isEmpty,
                      let bookCase = state.bookCase else {
                    return .none
                }
                
                state.isLoading = true
                state.errorMessage = nil
                
                let wordInput = state.wordInput
                let definitionInput = state.definitionInput
                let bookCaseName = state.bookCaseName
                let isEditing = state.isEditing
                let existingWord = state.existingWord
                
                if isEditing, let existingWord = existingWord {
                    return .run { send in
                        do {
                            try await coreDataDependency.updateWord(
                                existingWord,
                                wordInput,
                                definitionInput
                            )
                            await send(.wordSaved)
                        } catch {
                            await send(.saveWordFailed("단어 수정에 실패했습니다."))
                        }
                    }
                } else {
                    return .run { send in
                        do {
                            let _ = try await coreDataDependency.createWord(
                                wordInput,
                                definitionInput,
                                bookCaseName,
                                bookCase
                            )
                            await send(.wordSaved)
                        } catch {
                            await send(.saveWordFailed("단어 저장에 실패했습니다."))
                        }
                    }
                }
                
            case .wordSaved:
                state.isLoading = false
                return .send(.resetForm)
                
            case let .saveWordFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            case .resetForm:
                state.wordInput = ""
                state.definitionInput = ""
                state.detailInput = ""
                state.pronunciationInput = ""
                state.synonymInput = ""
                state.antonymInput = ""
                state.errorMessage = nil
                return .none
                
            case let .setBookCase(bookCase):
                state.bookCase = bookCase
                state.bookCaseName = bookCase?.name ?? ""
                return .none
            }
        }
    }
}
