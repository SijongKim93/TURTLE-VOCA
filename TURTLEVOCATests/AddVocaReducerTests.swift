//
//  AddVocaReducerTests.swift
//  TURTLEVOCATests
//
//  Created by 김시종 on 10/2/25.
//

import XCTest
import ComposableArchitecture
import CoreData
@testable import TURTLEVOCA

@MainActor
final class AddVocaReducerTests: XCTestCase {
    
    // MARK: - 기본 단어 생성 테스트
    
    func testCreateWordWithMinimalInput() async throws {
        let testBookCase = createTestBookCase()
        let testWord = createTestWordEntity(word: "test", definition: "테스트")
        
        let store = TestStore(
            initialState: AddVocaReducer.State(bookCase: testBookCase)
        ) {
            AddVocaReducer()
        } withDependencies: {
            $0.coreDataDependency.createWord = { _, _, _, _ in testWord }
            $0.coreDataDependency.getWordsFromBookCase = { _ in [] }
        }
        
        // Given: 단어와 의미만 입력
        await store.send(.wordForm(.wordInputChanged("test"))) { state in
            state.wordForm.wordInput = "test"
        }
        
        await store.send(.wordForm(.definitionInputChanged("테스트"))) { state in
            state.wordForm.definitionInput = "테스트"
        }
        
        // When: 단어 저장
        await store.send(.wordForm(.saveWord)) { state in
            state.wordForm.isLoading = true
            state.wordForm.errorMessage = nil
        }
        
        // Then: 저장 완료
        await store.receive(\.wordForm.wordSaved) { state in
            state.wordForm.isLoading = false
            state.wordForm.wordInput = ""
            state.wordForm.definitionInput = ""
            state.wordForm.detailInput = ""
            state.wordForm.pronunciationInput = ""
            state.wordForm.synonymInput = ""
            state.wordForm.antonymInput = ""
            state.wordForm.errorMessage = nil
        }
    }
    
    // MARK: - 필수 필드 검증 테스트
    
    func testCreateWordWithoutDefinition() async throws {
        let testBookCase = createTestBookCase()
        
        let store = TestStore(
            initialState: AddVocaReducer.State(bookCase: testBookCase)
        ) {
            AddVocaReducer()
        } withDependencies: {
            $0.coreDataDependency.getWordsFromBookCase = { _ in [] }
        }
        
        // Given: 단어만 입력 (의미는 비워둠)
        await store.send(.wordForm(.wordInputChanged("test"))) { state in
            state.wordForm.wordInput = "test"
        }
        
        // When: 저장 시도
        await store.send(.wordForm(.saveWord)) { state in
            state.wordForm.isLoading = true
            state.wordForm.errorMessage = nil
        }
        
        // Then: 검증 실패
        await store.receive(\.wordForm.saveWordFailed) { state in
            state.wordForm.isLoading = false
            state.wordForm.errorMessage = "단어와 의미를 모두 입력해주세요."
        }
    }
    
    // MARK: - 단어 목록 로드 테스트
    
    func testLoadWordsFromBookCase() async throws {
        let testBookCase = createTestBookCase()
        let testWords = [
            createTestWordEntity(word: "apple", definition: "사과"),
            createTestWordEntity(word: "banana", definition: "바나나")
        ]
        
        let store = TestStore(
            initialState: AddVocaReducer.State(bookCase: testBookCase)
        ) {
            AddVocaReducer()
        } withDependencies: {
            $0.coreDataDependency.getWordsFromBookCase = { _ in testWords }
        }
        
        // When: 단어 목록 로드
        await store.send(.wordList(.loadWords)) { state in
            state.wordList.isLoading = true
        }
        
        // Then: 단어 목록 로드 완료
        await store.receive(\.wordList.wordsLoaded) { state in
            state.wordList.words = testWords
            state.wordList.filteredWords = testWords
            state.wordList.isLoading = false
        }
    }
    
    // MARK: - 단어 삭제 테스트
    
    func testDeleteWord() async throws {
        let testBookCase = createTestBookCase()
        let testWord = createTestWordEntity(word: "test", definition: "테스트")
        
        let store = TestStore(
            initialState: AddVocaReducer.State(bookCase: testBookCase)
        ) {
            AddVocaReducer()
        } withDependencies: {
            $0.coreDataDependency.deleteWord = { _ in }
            $0.coreDataDependency.getWordsFromBookCase = { _ in [] }
        }
        
        
        // When: 단어 삭제
        await store.send(.wordList(.deleteWord(testWord)))
        
        // Then: 삭제 완료 후 목록 새로고침
        await store.receive(\.wordList.wordDeleted)
        await store.receive(\.wordList.refreshWords)
        await store.receive(\.wordList.loadWords)
    }
}

// MARK: - Test Helpers

extension AddVocaReducerTests {
    
    private func createTestBookCase() -> BookCase {
        let bookCase = BookCase()
        bookCase.name = "테스트 단어장"
        bookCase.uuid = UUID().uuidString
        return bookCase
    }
    
    private func createTestWordEntity(word: String, definition: String) -> WordEntity {
        let wordEntity = WordEntity()
        wordEntity.word = word
        wordEntity.definition = definition
        wordEntity.uuid = UUID().uuidString
        wordEntity.date = Date()
        wordEntity.memory = false
        return wordEntity
    }
}
