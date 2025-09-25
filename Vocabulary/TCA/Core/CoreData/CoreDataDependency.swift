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
    //Calendar
    var getWordFromCoreData: @Sendable (Date) async throws -> [WordEntity] = { _ in [] }
    var hasData: @Sendable (Date) async throws -> Bool = { _ in false }
    var updateWordMemoryStatus: @Sendable (WordEntity, Bool) async throws -> Void
    var deleteWord: @Sendable (WordEntity) async throws -> Void
    var markAllWordsAsLearned: @Sendable (Date) async throws -> Void
    var deleteAllWords: @Sendable (Date) async throws -> Void
    
    // MayPage
    var getSavedWordCount: @Sendable () async throws -> Int = { 0 }
    var getLearnedWordCount: @Sendable () async throws -> Int = { 0 }
    
    // BookCase
    var getBookCases: @Sendable () async throws -> [BookCase] = { [] }
    var createBookCase: @Sendable (String, Data?) async throws -> BookCase
    var updateBookCase: @Sendable (BookCase, String, Data?) async throws -> Void
    var deleteBookCase: @Sendable (BookCase) async throws -> Void
    
    // AddVoca
    var getWordsFromBookCase: @Sendable (BookCase?) async throws -> [WordEntity] = { _ in [] }
    var createWord: @Sendable (String, String, String, BookCase?) async throws -> WordEntity
    var updateWord: @Sendable (WordEntity, String, String) async throws -> Void
    var getWordCountForBookCase: @Sendable (BookCase?) async throws -> Int = { _ in 0 }
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
        },
        
        getSavedWordCount: {
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
                
                do {
                    let savedWordCount = try context.count(for: fetchRequest)
                    return savedWordCount
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        getLearnedWordCount: {
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
                fetchRequest.predicate = NSPredicate(format: "memory == true")
                
                do {
                    let learnedWordCount = try context.count(for: fetchRequest)
                    return learnedWordCount
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        getBookCases: {
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let fetchRequest: NSFetchRequest<BookCase> = BookCase.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                
                do {
                    return try context.fetch(fetchRequest)
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        createBookCase: { name, imageData in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let bookCase = BookCase(context: context)
                bookCase.name = name
                bookCase.image = imageData
                bookCase.uuid = UUID().uuidString
                
                do {
                    try context.save()
                    return bookCase
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        updateBookCase: { bookCase, name, imageData in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                bookCase.name = name
                bookCase.image = imageData
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        deleteBookCase: { bookCase in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                context.delete(bookCase)
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        // AddVoca 관련 메서드들
        getWordsFromBookCase: { bookCase in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let fetchRequest: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
                
                if let bookCase = bookCase {
                    fetchRequest.predicate = NSPredicate(format: "bookCaseName == %@", bookCase.name ?? "")
                }
                
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "word", ascending: true)]
                
                do {
                    return try context.fetch(fetchRequest)
                } catch {
                    throw CoreDataError.fetchFailed(error)
                }
            }
        },
        
        createWord: { word, definition, bookCaseName, bookCase in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let wordEntity = WordEntity(context: context)
                wordEntity.word = word
                wordEntity.definition = definition
                wordEntity.bookCaseName = bookCaseName
                wordEntity.date = Date()
                wordEntity.memory = false
                wordEntity.uuid = UUID().uuidString
                
                do {
                    try context.save()
                    return wordEntity
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        updateWord: { word, newWord, newDefinition in
            try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                word.word = newWord
                word.definition = newDefinition
                
                do {
                    try context.save()
                } catch {
                    throw CoreDataError.saveFailed(error)
                }
            }
        },
        
        getWordCountForBookCase: { bookCase in
            return try await MainActor.run {
                guard let context = getContext() else {
                    throw CoreDataError.contextNotAvailable
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
                
                if let bookCase = bookCase {
                    fetchRequest.predicate = NSPredicate(format: "bookCaseName == %@", bookCase.name ?? "")
                }
                
                do {
                    return try context.count(for: fetchRequest)
                } catch {
                    throw CoreDataError.fetchFailed(error)
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
        },
        
        getSavedWordCount: {
            return 15
        },
        
        getLearnedWordCount: {
            return 8
        },
        
        getBookCases: {
            return await generatePreviewBookCases()
        },
        
        createBookCase: { name, imageData in
            let bookCase = BookCase()
            bookCase.name = name
            bookCase.image = imageData
            bookCase.uuid = UUID().uuidString
            bookCase.word = ""
            bookCase.meaning = ""
            bookCase.explain = ""
            return bookCase
        },
        
        updateBookCase: { bookCase, name, imageData in
            bookCase.name = name
            bookCase.image = imageData
        },
        
        deleteBookCase: { bookCase in
            print("Preview: Deleted book case '\(bookCase.name ?? "")'")
        },
        
        getWordsFromBookCase: { bookCase in
            return await generatePreviewWordsForBookCase(bookCase)
        },
        
        createWord: { word, definition, bookCaseName, bookCase in
            let wordEntity = WordEntity()
            wordEntity.word = word
            wordEntity.definition = definition
            wordEntity.bookCaseName = bookCaseName
            wordEntity.date = Date()
            wordEntity.memory = false
            wordEntity.uuid = UUID().uuidString
            return wordEntity
        },
        
        updateWord: { word, newWord, newDefinition in
            word.word = newWord
            word.definition = newDefinition
        },
        
        getWordCountForBookCase: { bookCase in
            return 5
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

@MainActor
private func generatePreviewBookCases() async -> [BookCase] {
    let previewData = [
        ("기본 단어장", Data?.none),
        ("토익 단어", Data?.none),
        ("수능 단어", Data?.none),
        ("일상 단어", Data?.none)
    ]
    
    return previewData.map { (name, imageData) in
        let bookCase = BookCase()
        bookCase.name = name
        bookCase.image = imageData
        bookCase.uuid = UUID().uuidString
        bookCase.word = ""
        bookCase.meaning = ""
        bookCase.explain = ""
        return bookCase
    }
}

@MainActor
private func generatePreviewWordsForBookCase(_ bookCase: BookCase?) async -> [WordEntity] {
    let previewData = [
        ("Apple", "사과", "과일"),
        ("Computer", "컴퓨터", "기술"),
        ("Swift", "스위프트", "프로그래밍"),
        ("TCA", "The Composable Architecture", "아키텍처"),
        ("iOS", "아이오에스", "운영체제")
    ]
    
    return previewData.map { (word, definition, bookCaseName) in
        let entity = WordEntity()
        entity.word = word
        entity.definition = definition
        entity.bookCaseName = bookCase?.name ?? bookCaseName
        entity.date = Date()
        entity.memory = Bool.random()
        entity.uuid = UUID().uuidString
        return entity
    }
}
