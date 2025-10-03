//
//  BookCaseListReducerTests.swift
//  TURTLEVOCATests
//
//  Created by 김시종 on 10/2/25.
//

import XCTest
import ComposableArchitecture
@testable import TURTLEVOCA

@MainActor
final class BookCaseListReducerTests: XCTestCase {
    
    // MARK: - 북케이스 목록 로딩 테스트
    
    func testOnAppearLoadsBookCasesSuccess() async throws {
        let mockBookCases = createMockBookCases()
        let mockCoreData = createSuccessMockCoreData(bookCases: mockBookCases)
        
        let store = TestStore(
            initialState: BookCaseListReducer.State()
        ) {
            BookCaseListReducer()
        } withDependencies: {
            $0.coreDataDependency = mockCoreData
        }
        
        // When: 화면이 나타날 때
        await store.send(BookCaseListReducer.Action.onAppear) { state in
            // onAppear는 즉시 loadBookCases를 호출하므로 상태 변경 없음
        }
        
        // Then: 북케이스 로딩 액션 확인
        await store.receive(.loadBookCases) { state in
            state.isLoading = true
        }
        
        // Then: 북케이스 로딩 완료 확인
        await store.receive(.bookCasesLoaded(mockBookCases)) { state in
            state.bookCases = mockBookCases
            state.isLoading = false
        }
    }
    
    func testOnAppearLoadsBookCasesFailure() async throws {
        let mockCoreData = createFailureMockCoreData()
        
        let store = TestStore(
            initialState: BookCaseListReducer.State()
        ) {
            BookCaseListReducer()
        } withDependencies: {
            $0.coreDataDependency = mockCoreData
        }
        
        // When: 화면이 나타날 때
        await store.send(BookCaseListReducer.Action.onAppear) { state in
            // onAppear는 즉시 loadBookCases를 호출하므로 상태 변경 없음
        }
        
        // Then: 북케이스 로딩 액션 확인
        await store.receive(.loadBookCases) { state in
            state.isLoading = true
        }
        
        // Then: 로딩 실패 확인 (빈 배열로 로드됨)
        await store.receive(.bookCasesLoaded([])) { state in
            state.bookCases = []
            state.isLoading = false
        }
    }
    
    // MARK: - 북케이스 삭제 테스트
    
    func testDeleteBookCaseSuccess() async throws {
        // Given: Mock 북케이스 데이터
        let mockBookCases = createMockBookCases()
        let bookCaseToDelete = mockBookCases[0]
        let remainingBookCases = mockBookCases.filter { $0 != bookCaseToDelete }
        let mockCoreData = createSuccessMockCoreData(bookCases: remainingBookCases)
        
        var initialState = BookCaseListReducer.State()
        initialState.bookCases = mockBookCases
        
        let store = TestStore(
            initialState: initialState
        ) {
            BookCaseListReducer()
        } withDependencies: {
            $0.coreDataDependency = mockCoreData
        }
        
        // When: 북케이스 삭제
        await store.send(BookCaseListReducer.Action.deleteBookCase(bookCaseToDelete)) { state in
            // deleteBookCase는 즉시 .run을 실행하므로 상태 변경 없음
        }
        
        // Then: 삭제 완료 확인 (실제로는 loadBookCases를 다시 호출)
        await store.receive(.bookCaseDeleted) { state in
            // bookCaseDeleted는 loadBookCases를 다시 호출하므로 상태 변경 없음
        }
        
        // Then: 북케이스 로딩 액션 확인
        await store.receive(.loadBookCases) { state in
            state.isLoading = true
        }
        
        // Then: 북케이스 로딩 완료 확인 (삭제된 북케이스가 제외된 목록)
        await store.receive(.bookCasesLoaded(remainingBookCases)) { state in
            state.bookCases = remainingBookCases
            state.isLoading = false
        }
    }
    
    // MARK: - Helper Methods
    
    private func createMockBookCases() -> [BookCase] {
        let bookCase1 = BookCase()
        bookCase1.name = "영어 단어장"
        bookCase1.explain = "영어 학습용 단어장"
        
        let bookCase2 = BookCase()
        bookCase2.name = "일본어 단어장"
        bookCase2.explain = "일본어 학습용 단어장"
        
        return [bookCase1, bookCase2]
    }
    
    private func createSuccessMockCoreData(bookCases: [BookCase] = []) -> CoreDataDependency {
        return CoreDataDependency(
            getWordFromCoreData: { _ in [] },
            hasData: { _ in false },
            updateWordMemoryStatus: { _, _ in },
            deleteWord: { _ in },
            markAllWordsAsLearned: { _ in },
            deleteAllWords: { _ in },
            getSavedWordCount: { 0 },
            getLearnedWordCount: { 0 },
            getBookCases: { bookCases },
            createBookCase: { _, _, _, _, _ in
                let bookCase = BookCase()
                bookCase.name = "새 단어장"
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
