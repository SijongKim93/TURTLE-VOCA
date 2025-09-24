//
//  MyPageReducer.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/24/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct MyPageReducer {
    @Dependency(\.coreDataDependency) var coreDataDependency
    
    @ObservableState
    struct State {
        var savedWordCount: Int = 0
        var learnedWordCount: Int = 0
        var gamePlayCount: Int = 0
        
        init() {}
    }
    
    enum Action {
        case onAppear
        case loadWordCount
        case wordCountsLoaded(Int, Int)
        case updateGameCount(Int)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.loadWordCount)
                
            case .loadWordCount:
                return .run { send in
                    do {
                        let savedCount = try await coreDataDependency.getSavedWordCount()
                        let learnedCount = try await coreDataDependency.getLearnedWordCount()
                        await send(.wordCountsLoaded(savedCount, learnedCount))
                    } catch {
                        await send(.wordCountsLoaded(0, 0))
                    }
                }
                
            case let .wordCountsLoaded(savedCount, learnedCount):
                state.savedWordCount = savedCount
                state.learnedWordCount = learnedCount
                return .none
                
            case .updateGameCount(let count):
                state.gamePlayCount = count
                return .none
            }
        }
    }
}
