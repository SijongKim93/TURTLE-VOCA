//
//  BookCaseFormReducerTests.swift
//  TURTLEVOCATests
//
//  Created by 김시종 on 10/2/25.
//

import XCTest
import ComposableArchitecture
@testable import TURTLEVOCA

@MainActor
final class BookCaseFormReducerTests: XCTestCase {
    
    // MARK: - 북케이스 생성 성공 테스트
    
    func testCreateBookCaseSuccess() async throws {
        // Given: 성공하는 Mock CoreData 설정
        let mockCoreData = createSuccessMockCoreData()
        
        let store = TestStore(
            initialState: BookCaseFormReducer.State()
        ) {
            BookCaseFormReducer()
        } withDependencies: {
            $0.coreDataDependency = mockCoreData
        }
        
        // When: 북케이스 생성 액션들 실행
        await store.send(BookCaseFormReducer.Action.nameChanged("테스트 단어장")) { state in
            state.name = "테스트 단어장"
        }
        
        await store.send(BookCaseFormReducer.Action.explainChanged("테스트용 단어장입니다")) { state in
            state.explain = "테스트용 단어장입니다"
        }
        
        await store.send(BookCaseFormReducer.Action.wordChanged("apple")) { state in
            state.word = "apple"
        }
        
        await store.send(BookCaseFormReducer.Action.meaningChanged("사과")) { state in
            state.meaning = "사과"
        }
        
        await store.send(BookCaseFormReducer.Action.saveBookCase) { state in
            state.isLoading = true
        }
        
        // Then: 성공 응답 확인
        await store.receive(.bookCaseSaved) { state in
            state.isLoading = false
            state.errorMessage = nil
        }
        
        await store.receive(.clearForm) { state in
            state.name = ""
            state.explain = ""
            state.word = ""
            state.meaning = ""
            state.imageData = nil
        }
    }
    
    // MARK: - 북케이스 생성 실패 테스트
    
    func testCreateBookCaseFailure() async throws {
        // Given: 실패하는 Mock CoreData 설정
        let mockCoreData = createFailureMockCoreData()
        
        let store = TestStore(
            initialState: BookCaseFormReducer.State()
        ) {
            BookCaseFormReducer()
        } withDependencies: {
            $0.coreDataDependency = mockCoreData
        }
        
        // When: 북케이스 생성 시도
        await store.send(BookCaseFormReducer.Action.nameChanged("실패할 단어장")) { state in
            state.name = "실패할 단어장"
        }
        
        await store.send(BookCaseFormReducer.Action.wordChanged("test")) { state in
            state.word = "test"
        }
        
        await store.send(BookCaseFormReducer.Action.meaningChanged("테스트")) { state in
            state.meaning = "테스트"
        }
        
        await store.send(BookCaseFormReducer.Action.saveBookCase) { state in
            state.isLoading = true
        }
        
        // Then: 실패 응답 확인
        await store.receive(.saveFailed("단어장 생성에 실패했습니다.")) { state in
            state.isLoading = false
            state.errorMessage = "단어장 생성에 실패했습니다."
        }
    }
    
    // MARK: - 빈 이름 검증 테스트
    
    func testCreateBookCaseEmptyNameShowsError() async throws {
        let store = TestStore(
            initialState: BookCaseFormReducer.State()
        ) {
            BookCaseFormReducer()
        }
        
        // When: 빈 이름으로 저장 시도
        await store.send(BookCaseFormReducer.Action.saveBookCase) { state in
            // 빈 이름이므로 isLoading은 변경되지 않고 errorMessage만 설정됨
            state.errorMessage = "단어장 이름을 입력해주세요."
        }
    }
    
    // MARK: - 공백만 있는 이름 검증 테스트
    
    func testCreateBookCaseOnlySpacesShowsError() async throws {
        let store = TestStore(
            initialState: BookCaseFormReducer.State()
        ) {
            BookCaseFormReducer()
        }
        
        // When: 공백만 있는 이름으로 저장 시도
        await store.send(BookCaseFormReducer.Action.nameChanged("   ")) { state in
            state.name = "   "
        }
        
        await store.send(BookCaseFormReducer.Action.saveBookCase) { state in
            // 공백만 있는 이름이므로 isLoading은 변경되지 않고 errorMessage만 설정됨
            state.errorMessage = "단어장 이름을 입력해주세요."
        }
    }
    
    // MARK: - 폼 리셋 테스트
    
    func testResetForm() async throws {
        var initialState = BookCaseFormReducer.State()
        initialState.name = "테스트"
        initialState.explain = "설명"
        initialState.word = "word"
        initialState.meaning = "의미"
        
        let store = TestStore(
            initialState: initialState
        ) {
            BookCaseFormReducer()
        }
        
        // When: 폼 리셋
        await store.send(BookCaseFormReducer.Action.reset) { state in
            state.name = ""
            state.explain = ""
            state.word = ""
            state.meaning = ""
            state.imageData = nil
            state.errorMessage = nil
            state.isLoading = false
        }
    }
    
    // MARK: - Helper Methods
    
    private func createSuccessMockCoreData() -> CoreDataDependency {
        return CoreDataDependency(
            getWordFromCoreData: { _ in [] },
            hasData: { _ in false },
            updateWordMemoryStatus: { _, _ in },
            deleteWord: { _ in },
            markAllWordsAsLearned: { _ in },
            deleteAllWords: { _ in },
            getSavedWordCount: { 0 },
            getLearnedWordCount: { 0 },
            getBookCases: { [] },
            createBookCase: { _, _, _, _, _ in
                let bookCase = BookCase()
                bookCase.name = "테스트 단어장"
                return bookCase
            },
            updateBookCase: { _, _, _, _, _, _ in },
            deleteBookCase: { _ in },
            getWordsFromBookCase: { _ in [] },
            createWord: { _, _, _, _ in WordEntity() },
            updateWord: { _, _, _ in },
            getWordCountForBookCase: { _ in 0 }
        )
    }
    
    private func createFailureMockCoreData() -> CoreDataDependency {
        return CoreDataDependency(
            getWordFromCoreData: { _ in throw NSError(domain: "TestError", code: 1) },
            hasData: { _ in throw NSError(domain: "TestError", code: 1) },
            updateWordMemoryStatus: { _, _ in throw NSError(domain: "TestError", code: 1) },
            deleteWord: { _ in throw NSError(domain: "TestError", code: 1) },
            markAllWordsAsLearned: { _ in throw NSError(domain: "TestError", code: 1) },
            deleteAllWords: { _ in throw NSError(domain: "TestError", code: 1) },
            getSavedWordCount: { throw NSError(domain: "TestError", code: 1) },
            getLearnedWordCount: { throw NSError(domain: "TestError", code: 1) },
            getBookCases: { throw NSError(domain: "TestError", code: 1) },
            createBookCase: { _, _, _, _, _ in throw NSError(domain: "TestError", code: 1) },
            updateBookCase: { _, _, _, _, _, _ in throw NSError(domain: "TestError", code: 1) },
            deleteBookCase: { _ in throw NSError(domain: "TestError", code: 1) },
            getWordsFromBookCase: { _ in throw NSError(domain: "TestError", code: 1) },
            createWord: { _, _, _, _ in throw NSError(domain: "TestError", code: 1) },
            updateWord: { _, _, _ in throw NSError(domain: "TestError", code: 1) },
            getWordCountForBookCase: { _ in throw NSError(domain: "TestError", code: 1) }
        )
    }
}