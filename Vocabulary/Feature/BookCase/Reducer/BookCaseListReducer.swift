//
//  BookCaseListReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 10/1/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct BookCaseListReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State: Equatable {
        var bookCases: [BookCase] = []
        var isLoading: Bool = false
        var selectedBookCase: BookCase?
        
        init() {}
    }
    
    enum Action: Equatable {
        case onAppear
        case loadBookCases
        case bookCasesLoaded([BookCase])
        case bookCaseSelected(BookCase)
        case deleteBookCase(BookCase)
        case refreshBookCases
        case bookCaseDeleted
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
                        print("❌ BookCaseListReducer: 단어장 목록 로드 실패 - \(error)")
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
                
            case let .deleteBookCase(bookCase):
                return .run { send in
                    do {
                        try await coreDataDependency.deleteBookCase(bookCase)
                        await send(.bookCaseDeleted)
                    } catch {
                        print("❌ BookCaseListReducer: 단어장 삭제 실패 - \(error)")
                    }
                }
                
            case .refreshBookCases:
                return .send(.loadBookCases)
                
            case .bookCaseDeleted:
                return .send(.loadBookCases)
            }
        }
    }
}
