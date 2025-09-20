//
//  CoreDataManagerDependency.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/18/25.
//

import ComposableArchitecture
import Foundation
import CoreData
import UIKit

@DependencyClient
struct CoreDataDependency {
    var getWordFromCoreData: @Sendable (Date) async throws -> [WordEntity] = { _ in [] }
    var hasData: @Sendable (Date) async throws -> Bool = { _ in false }
    var updateWordMemoryStatus: @Sendable (WordEntity, Bool) async throws -> Void
    var deleteWord: @Sendable (WordEntity) async throws -> Void
    var markAllWordsAsLearned: @Sendable (Date) async throws -> Void
    var deleteAllWords: @Sendable (Date) async throws -> Void
}

extension CoreDataDependency: DependencyKey {
    static let liveValue = Self(
        getWordFromCoreData: { date in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: date)
                guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                    throw CoreDataError.invalidDate
                }
                
                let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
                let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
                request.predicate = predicate
                
                do {
                    return try context.fetch(request)
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        hasData: { date in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: date)
                guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                    throw CoreDataError.invalidDate
                }
                
                let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
                let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
                request.predicate = predicate
                
                do {
                    let count = try context.count(for: request)
                    return count > 0
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        updateWordMemoryStatus: { word, memory in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                word.memory = memory
            
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        deleteWord: { word in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                context.delete(word)
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        markAllWordsAsLearned: { date in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: date)
                guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                    throw CoreDataError.invalidDate
                }
                
                let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
                let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
                request.predicate = predicate
                
                let words: [WordEntity]
                do {
                    words = try context.fetch(request)
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
                
                for word in words {
                    word.memory = true
                }
                
                // 한 번에 저장
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.batchUpdateFailed(error)
                }
            }
        },
        
        deleteAllWords: { date in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                // 해당 날짜의 모든 단어 조회
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: date)
                guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
                    throw CoreDataError.invalidDate
                }
                
                let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
                let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
                request.predicate = predicate
                
                let words: [WordEntity]
                do {
                    words = try context.fetch(request)
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
                
                // 모든 단어 삭제
                for word in words {
                    context.delete(word)
                }
                
                // 한 번에 저장
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.batchDeleteFailed(error)
                }
            }
        }
    )
    
    // MARK: - Preview Value
    static let previewValue = Self(
        getWordFromCoreData: { date in
            return await generatePreviewWords(for: date)
        },
        
        hasData: { date in
            let day = Calendar.current.component(.day, from: date)
            return day % 3 == 0
        },
        
        updateWordMemoryStatus: { word, memory in
            print("Preview: Updated '\(word.word ?? "")' memory to \(memory)")
            word.memory = memory
        },
        
        deleteWord: { word in
            print("Preview: Deleted word '\(word.word ?? "")'")
        },
        
        markAllWordsAsLearned: { date in
            print("Preview: Marked all words as learned for \(date)")
        },
        
        deleteAllWords: { date in
            print("Preview: Deleted all words for \(date)")
        }
    )
}

// MARK: - Helper Functions
private func getContext() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
    }
    return appDelegate.persistentContainer.viewContext
}

// MARK: - DependencyValues Extension
extension DependencyValues {
    var coreDataDependency: CoreDataDependency {
        get { self[CoreDataDependency.self] }
        set { self[CoreDataDependency.self] = newValue }
    }
}

// MARK: - Preview Helper Functions
@MainActor
private func generatePreviewWords(for date: Date) async -> [WordEntity] {
    let previewData = [
        ("Apple", "사과", "과일"),
        ("Computer", "컴퓨터", "기술"),
        ("Swift", "스위프트", "프로그래밍"),
        ("TCA", "The Composable Architecture", "아키텍처")
    ]
    
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    let numberOfWords = max(1, day % 4)
    
    return Array(previewData.prefix(numberOfWords)).map { (word, definition, bookCase) in
        let entity = WordEntity()
        entity.word = word
        entity.definition = definition
        entity.bookCaseName = bookCase
        entity.date = date
        entity.memory = Bool.random()
        entity.uuid = UUID().uuidString
        return entity
    }
}
