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
        
        // 편집 중인 임시 데이터
        var editingWord: String = ""
        var editingDefinition: String = ""
        var editingDetail: String = ""
        var editingPronunciation: String = ""
        var editingSynonym: String = ""
        var editingAntonym: String = ""
        
        init(word: WordEntity) {
            self.word = word
            self.editingWord = word.word ?? ""
            self.editingDefinition = word.definition ?? ""
            self.editingDetail = word.detail ?? ""
            self.editingPronunciation = word.pronunciation ?? ""
            self.editingSynonym = word.synonym ?? ""
            self.editingAntonym = word.antonym ?? ""
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
        
        // 편집 필드 업데이트 액션
        case updateEditingWord(String)
        case updateEditingDefinition(String)
        case updateEditingDetail(String)
        case updateEditingPronunciation(String)
        case updateEditingSynonym(String)
        case updateEditingAntonym(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editButtonTapped:
                state.isEditing = true
                // 편집 시작 시 현재 값으로 초기화
                state.editingWord = state.word.word ?? ""
                state.editingDefinition = state.word.definition ?? ""
                state.editingDetail = state.word.detail ?? ""
                state.editingPronunciation = state.word.pronunciation ?? ""
                state.editingSynonym = state.word.synonym ?? ""
                state.editingAntonym = state.word.antonym ?? ""
                return .none
                
            case .cancelEdit:
                state.isEditing = false
                state.errorMessage = nil
                // 편집 취소 시 원래 값으로 복원
                state.editingWord = state.word.word ?? ""
                state.editingDefinition = state.word.definition ?? ""
                state.editingDetail = state.word.detail ?? ""
                state.editingPronunciation = state.word.pronunciation ?? ""
                state.editingSynonym = state.word.synonym ?? ""
                state.editingAntonym = state.word.antonym ?? ""
                return .none
                
            case .saveChanges:
                state.isLoading = true
                state.errorMessage = nil
                
                // 편집된 값들을 word에 반영
                state.word.word = state.editingWord
                state.word.definition = state.editingDefinition
                state.word.detail = state.editingDetail
                state.word.pronunciation = state.editingPronunciation
                state.word.synonym = state.editingSynonym
                state.word.antonym = state.editingAntonym
                
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
                
            // 편집 필드 업데이트 처리
            case let .updateEditingWord(value):
                state.editingWord = value
                return .none
                
            case let .updateEditingDefinition(value):
                state.editingDefinition = value
                return .none
                
            case let .updateEditingDetail(value):
                state.editingDetail = value
                return .none
                
            case let .updateEditingPronunciation(value):
                state.editingPronunciation = value
                return .none
                
            case let .updateEditingSynonym(value):
                state.editingSynonym = value
                return .none
                
            case let .updateEditingAntonym(value):
                state.editingAntonym = value
                return .none
            }
        }
    }
}
