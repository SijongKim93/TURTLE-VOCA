//
//  AddVocaReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct AddVocaReducer {
    @ObservableState
    struct State: Equatable {
        var bookCase: BookCase?
        var bookCaseName: String = ""
        
        var wordList = WordListReducer.State()
        var wordForm = WordFormReducer.State()
        var translation = TranslationReducer.State()
        var wordDetail: WordDetailReducer.State? = nil
        
        var isShowingInsertVoca: Bool = false
        var isShowingWordDetail: Bool = false
        
        init(bookCase: BookCase? = nil) {
            self.bookCase = bookCase
            self.bookCaseName = bookCase?.name ?? ""
            self.wordList = WordListReducer.State(bookCase: bookCase)
            self.wordForm = WordFormReducer.State(bookCase: bookCase)
        }
    }
    
    enum Action {
        case onAppear
        case setBookCase(BookCase?)
        case wordList(WordListReducer.Action)
        case wordForm(WordFormReducer.Action)
        case translation(TranslationReducer.Action)
        case wordDetail(WordDetailReducer.Action)
        case addWordButtonTapped
        case dismissInsertVoca
        case showWordDetail(WordEntity)
        case dismissWordDetail
        case wordSaved
        case wordUpdated
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.wordList, action: \.wordList) {
            WordListReducer()
        }
        
        Scope(state: \.wordForm, action: \.wordForm) {
            WordFormReducer()
        }
        
        Scope(state: \.translation, action: \.translation) {
            TranslationReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.wordList = WordListReducer.State(bookCase: state.bookCase)
                state.wordForm = WordFormReducer.State(bookCase: state.bookCase)
                return .send(.wordList(.loadWords))
                
            case let .setBookCase(bookCase):
                state.bookCase = bookCase
                state.bookCaseName = bookCase?.name ?? ""
                return .send(.wordList(.setBookCase(bookCase)))
                
            case .addWordButtonTapped:
                state.isShowingInsertVoca = true
                state.wordForm = WordFormReducer.State(bookCase: state.bookCase)
                return .send(.translation(.clearResults))
                
            case .dismissInsertVoca:
                state.isShowingInsertVoca = false
                return .send(.wordList(.refreshWords))
                
            case let .showWordDetail(word):
                state.isShowingWordDetail = true
                state.wordDetail = WordDetailReducer.State(word: word)
                return .none
                
            case .dismissWordDetail:
                state.isShowingWordDetail = false
                state.wordDetail = nil
                return .send(.wordList(.refreshWords))
                
            case .wordForm(.wordSaved):
                state.isShowingInsertVoca = false
                return .send(.wordList(.refreshWords))
                
            case .wordDetail(.wordUpdated):
                state.isShowingWordDetail = false
                state.wordDetail = nil
                return .send(.wordList(.refreshWords))
                
            case let .wordList(.wordSelected(word)):
                return .send(.showWordDetail(word))
                
            case let .translation(.translationReceived(translations)):
                // 번역 결과를 받았을 때 첫 번째 번역을 자동으로 선택
                if let firstTranslation = translations.first {
                    return .send(.wordForm(.translationSelected(firstTranslation.text)))
                }
                return .none
                
            case let .translation(.translationFailed(message)):
                // 번역 실패 시 에러 처리 (필요시)
                return .none
                
            case let .wordForm(.wordInputChanged(text)):
                if !text.isEmpty {
                    return .run { send in
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        await send(.translation(.translateText(text)))
                    }
                } else {
                    return .send(.translation(.clearResults))
                }
                
            case .wordList, .wordForm, .translation, .wordDetail:
                return .none
                
            case .wordSaved, .wordUpdated:
                return .none
            }
        }
        .ifLet(\.wordDetail, action: \.wordDetail) {
            WordDetailReducer()
        }
    }
}
