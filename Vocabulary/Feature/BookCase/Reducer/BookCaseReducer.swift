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
    @ObservableState
    struct State {
        var bookCaseList = BookCaseListReducer.State()
        var bookCaseForm = BookCaseFormReducer.State()
        var navigation = BookCaseNavigationReducer.State()
        
        init() {}
    }
    
    enum Action {
        case onAppear
        case bookCaseList(BookCaseListReducer.Action)
        case bookCaseForm(BookCaseFormReducer.Action)
        case navigation(BookCaseNavigationReducer.Action)
        case addBookCaseButtonTapped
        case editBookCaseButtonTapped(BookCase)
        case bookCaseSelected(BookCase)
        case refreshBookCases
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.bookCaseList, action: \.bookCaseList) {
            BookCaseListReducer()
        }
        
        Scope(state: \.bookCaseForm, action: \.bookCaseForm) {
            BookCaseFormReducer()
        }
        
        Scope(state: \.navigation, action: \.navigation) {
            BookCaseNavigationReducer()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.bookCaseList(.onAppear))
                
            case .addBookCaseButtonTapped:
                return .send(.navigation(.showAddBookCase))
                
            case let .editBookCaseButtonTapped(bookCase):
                return .concatenate(
                    .send(.bookCaseForm(.reset)),
                    .send(.bookCaseForm(.initializeWithBookCase(bookCase))),
                    .send(.navigation(.showEditBookCase(bookCase)))
                )
                
            case let .bookCaseSelected(bookCase):
                return .concatenate(
                    .send(.bookCaseList(.bookCaseSelected(bookCase))),
                    .send(.navigation(.showAddVoca(bookCase)))
                )
                
            case .refreshBookCases:
                return .send(.bookCaseList(.refreshBookCases))
                
            // BookCaseForm과 BookCaseList 간의 연동
            case .bookCaseForm(.bookCaseSaved):
                return .concatenate(
                    .send(.navigation(.dismissAddBookCase)),
                    .send(.bookCaseList(.refreshBookCases))
                )
                
            case .bookCaseForm(.bookCaseUpdated):
                return .concatenate(
                    .send(.navigation(.dismissEditBookCase)),
                    .send(.bookCaseList(.refreshBookCases))
                )
                
            // BookCaseList와 Navigation 간의 연동
            case .bookCaseList(.bookCaseSelected(let bookCase)):
                return .send(.navigation(.setSelectedBookCase(bookCase)))
                
            case .bookCaseList(.bookCaseDeleted):
                return .send(.navigation(.clearSelectedBookCase))
                
            // Navigation과 BookCaseForm 간의 연동
            case .navigation(.dismissAddBookCase):
                return .send(.bookCaseForm(.reset))
                
            case .navigation(.dismissEditBookCase):
                return .send(.bookCaseForm(.reset))
                
            case .bookCaseList, .bookCaseForm, .navigation:
                return .none
            }
        }
    }
}
