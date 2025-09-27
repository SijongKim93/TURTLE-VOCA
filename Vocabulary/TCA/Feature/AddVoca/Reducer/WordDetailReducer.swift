//
//  WordDetailReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/26/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct WordDetailReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State: Equatable {
        var word: WordEntity
        var isEditing: Bool = false
        var isLoading: Bool = false
        var errorMessage: String?
        
        init(word: WordEntity) {
            self.word = word
        }
    }
    
    enum Action: Equatable {
        case editButtonTapped
        case cancelEdit
        case saveChanges
        case wordUpdated
        case updateFailed(String)
        case toggleMemoryStatus
        case memoryStatusUpdated
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editButtonTapped:
                state.isEditing = true
                return .none
                
            case .cancelEdit:
                state.isEditing = false
                state.errorMessage = nil
                return .none
                
            case .saveChanges:
                state.isLoading = true
                state.errorMessage = nil
                
                return .run { [word = state.word] send in
                    do {
                        try await coreDataDependency.updateWord(
                            word,
                            word.word ?? "",
                            word.definition ?? ""
                        )
                        await send(.wordUpdated)
                    } catch {
                        await send(.updateFailed("단어 수정에 실패했습니다."))
                    }
                }
                
            case .wordUpdated:
                state.isLoading = false
                state.isEditing = false
                return .none
                
            case let .updateFailed(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
                
            case .toggleMemoryStatus:
                let newMemoryStatus = !state.word.memory
                state.word.memory = newMemoryStatus
                
                return .run { [word = state.word] send in
                    do {
                        try await coreDataDependency.updateWordMemoryStatus(word, newMemoryStatus)
                        await send(.memoryStatusUpdated)
                    } catch {
                        print("암기 상태 업데이트 실패: \(error)")
                    }
                }
                
            case .memoryStatusUpdated:
                return .none
            }
        }
    }
}
