//
//  BookCaseNavigationReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import ComposableArchitecture
import SwiftUI
import CoreData

@Reducer
struct BookCaseNavigationReducer {
    @ObservableState
    struct State {
        var isShowingAddBookCase: Bool = false
        var isShowingEditBookCase: Bool = false
        var isShowingAddVoca: Bool = false
        var selectedBookCase: BookCase?
        
        init() {}
    }
    
    enum Action {
        case showAddBookCase
        case showEditBookCase(BookCase)
        case showAddVoca(BookCase)
        case dismissAddBookCase
        case dismissEditBookCase
        case dismissAddVoca
        case setSelectedBookCase(BookCase?)
        case clearSelectedBookCase
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .showAddBookCase:
                state.isShowingAddBookCase = true
                return .none
                
            case let .showEditBookCase(bookCase):
                state.selectedBookCase = bookCase
                state.isShowingEditBookCase = true
                return .none
                
            case let .showAddVoca(bookCase):
                state.selectedBookCase = bookCase
                state.isShowingAddVoca = true
                return .none
                
            case .dismissAddBookCase:
                state.isShowingAddBookCase = false
                return .none
                
            case .dismissEditBookCase:
                state.isShowingEditBookCase = false
                state.selectedBookCase = nil
                return .none
                
            case .dismissAddVoca:
                state.isShowingAddVoca = false
                state.selectedBookCase = nil
                return .none
                
            case let .setSelectedBookCase(bookCase):
                state.selectedBookCase = bookCase
                return .none
                
            case .clearSelectedBookCase:
                state.selectedBookCase = nil
                return .none
            }
        }
    }
}
