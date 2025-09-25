//
//  BookCaseReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct BookCaseReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State {
        var bookCases: [BookCase] = []
        var isLoading: Bool = false
        var selectedBookCase: BookCase?
        var isShowingAddBookCase: Bool = false
        var isShowingEditBookCase: Bool = false
        
        init() {}
    }
    
    enum Action {
        case onAppear
        case loadBookCases
        case bookCasesLoaded([BookCase])
        case bookCaseSelected(BookCase)
        case addBookCaseButtonTapped
        case editBookCaseButtonTapped(BookCase)
        case deleteBookCase(BookCase)
        case dismissAddBookCase
        case dismissEditBookCase
        case refreshBookCases
        
        case createBookCase(String, Data?)
        case updateBookCase(BookCase, String, Data?)
        case bookCaseCreated(BookCase)
        case bookCaseUpdated
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadBookCases)
                
            case .loadBookCases:
                state.isLoading = true
                return .run { send in
                    do {
                        let bookCases = try await coreDataDependency.getBookCases()
                        await send(.bookCasesLoaded(bookCases))
                    } catch {
                        print("❌ BookCaseReducer: 단어장 목록 로드 실패 - \(error)")
                        await send(.bookCasesLoaded([]))
                    }
                }
                
            case let .bookCasesLoaded(bookCases):
                state.bookCases = bookCases
                state.isLoading = false
                return .none
                
            case let .bookCaseSelected(bookCase):
                state.selectedBookCase = bookCase
                return .none
                
            case .addBookCaseButtonTapped:
                state.isShowingAddBookCase = true
                return .none
                
            case let .editBookCaseButtonTapped(bookCase):
                state.selectedBookCase = bookCase
                state.isShowingEditBookCase = true
                return .none
                
            case let .deleteBookCase(bookCase):
                return .run { send in
                    do {
                        try await coreDataDependency.deleteBookCase(bookCase)
                        await send(.refreshBookCases)
                    } catch {
                        print("❌ BookCaseReducer: 단어장 삭제 실패 - \(error)")
                    }
                }
                
            case .dismissAddBookCase:
                state.isShowingAddBookCase = false
                return .send(.refreshBookCases)
                
            case .dismissEditBookCase:
                state.isShowingEditBookCase = false
                state.selectedBookCase = nil
                return .send(.refreshBookCases)
                
            case .refreshBookCases:
                return .send(.loadBookCases)
                
            case let .createBookCase(name, imageData):
                return .run { send in
                    do {
                        let bookCase = try await coreDataDependency.createBookCase(name, imageData)
                        await send(.bookCaseCreated(bookCase))
                    } catch {
                        print("단어장 생성 실패")
                    }
                }
                
            case let .updateBookCase(bookCase, name, imageData):
                return .run { send in
                    do {
                        try await coreDataDependency.updateBookCase(bookCase, name, imageData)
                        await send(.bookCaseUpdated)
                    } catch {
                        print("단어장 수정 실패")
                    }
                }
                
            case .bookCaseCreated:
                return .send(.dismissAddBookCase)
                
            case .bookCaseUpdated:
                return .send(.dismissEditBookCase)
            }
        }
    }
}
