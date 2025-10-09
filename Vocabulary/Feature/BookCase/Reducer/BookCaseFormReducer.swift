//
//  BookCaseFormReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct BookCaseFormReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State: Equatable {
        var name: String = ""
        var imageData: Data?
        var explain: String = ""
        var word: String = ""
        var meaning: String = ""
        var isLoading: Bool = false
        var errorMessage: String?
        var isEditing: Bool = false
        var existingBookCase: BookCase?
        
        init() {}
    }
    
    enum Action: Equatable {
        case nameChanged(String)
        case imageDataChanged(Data?)
        case explainChanged(String)
        case wordChanged(String)
        case meaningChanged(String)
        case saveBookCase
        case updateBookCase
        case bookCaseSaved
        case bookCaseUpdated
        case saveFailed(String)
        case clearForm
        case reset
        case initializeWithBookCase(BookCase)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .nameChanged(name):
                state.name = name
                return .none
                
            case let .imageDataChanged(imageData):
                state.imageData = imageData
                return .none
                
            case let .explainChanged(explain):
                state.explain = explain
                return .none
                
            case let .wordChanged(word):
                state.word = word
                return .none
                
            case let .meaningChanged(meaning):
                state.meaning = meaning
                return .none
                
            case .saveBookCase:
                guard !state.name.isEmpty else {
                    state.errorMessage = "단어장의 명칭을 적어주세요."
                    return .none
                }
                
                state.isLoading = true
                state.errorMessage = nil
                
                let name = state.name
                let imageData = state.imageData
                let explain = state.explain
                let word = state.word
                let meaning = state.meaning
                
                return .run { send in
                    do {
                        let _ = try await coreDataDependency.createBookCase(name, imageData, explain, word, meaning)
                        await send(.bookCaseSaved)
                    } catch {
                        await send(.saveFailed("단어장 생성에 실패했습니다."))
                    }
                }
                
            case .updateBookCase:
                guard !state.name.isEmpty,
                      let existingBookCase = state.existingBookCase else {
                    state.errorMessage = "단어장 정보가 올바르지 않습니다."
                    return .none
                }
                
                state.isLoading = true
                state.errorMessage = nil
                
                let bookCase = existingBookCase
                let name = state.name
                let imageData = state.imageData
                let explain = state.explain
                let word = state.word
                let meaning = state.meaning
                
                return .run { send in
                    do {
                        try await coreDataDependency.updateBookCase(bookCase, name, imageData, explain, word, meaning)
                        await send(.bookCaseUpdated)
                    } catch {
                        await send(.saveFailed("단어장 수정에 실패했습니다."))
                    }
                }
                
            case .bookCaseSaved:
                state.isLoading = false
                return .send(.clearForm)
                
            case .bookCaseUpdated:
                state.isLoading = false
                return .send(.clearForm)
                
            case let .saveFailed(errorMessage):
                state.isLoading = false
                state.errorMessage = errorMessage
                return .none
                
            case .clearForm:
                state.name = ""
                state.imageData = nil
                state.explain = ""
                state.word = ""
                state.meaning = ""
                state.errorMessage = nil
                return .none
                
            case .reset:
                state.name = ""
                state.imageData = nil
                state.explain = ""
                state.word = ""
                state.meaning = ""
                state.errorMessage = nil
                state.isLoading = false
                state.isEditing = false
                state.existingBookCase = nil
                return .none
                
            case let .initializeWithBookCase(bookCase):
                state.existingBookCase = bookCase
                state.name = bookCase.name ?? ""
                state.imageData = bookCase.image
                state.explain = bookCase.explain ?? ""
                state.word = bookCase.word ?? ""
                state.meaning = bookCase.meaning ?? ""
                state.isEditing = true
                return .none
            }
        }
    }
}
