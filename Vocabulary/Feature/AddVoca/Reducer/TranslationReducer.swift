//
//  TranslationReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct TranslationReducer {
    @Dependency(\.networkDependency) var networkDependency
    
    @ObservableState
    struct State: Equatable {
        var isTranslating: Bool = false
        var translationResults: [Translation] = []
        var errorMessage: String?
        var lastTranslatedText: String = ""
        
        init() {}
    }
    
    enum Action: Equatable {
        case translateText(String)
        case translationReceived([Translation])
        case translationFailed(String)
        case clearResults
        case setResults([Translation])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .translateText(text):
                guard !text.isEmpty && text != state.lastTranslatedText else {
                    return .none
                }
                
                state.isTranslating = true
                state.errorMessage = nil
                state.lastTranslatedText = text
                
                return .run { send in
                    do {
                        let translations = try await networkDependency.translateText(text)
                        await send(.translationReceived(translations))
                    } catch {
                        await send(.translationFailed("번역에 실패했습니다."))
                    }
                }
                
            case let .translationReceived(translations):
                state.isTranslating = false
                state.translationResults = translations
                return .none
                
            case let .translationFailed(message):
                state.isTranslating = false
                state.errorMessage = message
                state.translationResults = []
                return .none
                
            case .clearResults:
                state.translationResults = []
                state.errorMessage = nil
                state.lastTranslatedText = ""
                return .none
                
            case let .setResults(translations):
                state.translationResults = translations
                return .none
            }
        }
    }
}
