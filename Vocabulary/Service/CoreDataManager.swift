//
//  CoreDataManager.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/16/24.
//
import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    // MARK: - properties
    
    static let shared: CoreDataManager = CoreDataManager()
    private init() {}
    
    // AppDelegate에 접근하기 위한 프로퍼티
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not accessible.")
        }
        return appDelegate
    }
    
    // CoreData의 관리 객체 컨텍스트
    private var managedContext: NSManagedObjectContext? {
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - methods
    
    //단어장 추가
    func saveBookCase(name: String, explain: String, word: String, meaning: String, image: Data, errorHandler: @escaping (Error) -> Void) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "BookCase", in: context)!
        let bookCase = NSManagedObject(entity: entity, insertInto: context)
        
        bookCase.setValue(name, forKey: "name")
        bookCase.setValue(explain, forKey: "explain")
        bookCase.setValue(word, forKey: "word")
        bookCase.setValue(meaning, forKey: "meaning")
        bookCase.setValue(image, forKey: "image")
        
        do {
            try context.save()
            print("코어데이터가 저장되었습니다.")
        } catch let error as NSError {
            errorHandler(error)
        }
    }
    
    //단어장 가져오기
    func fetchBookCase() -> [NSManagedObject] {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return []
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookCase")
        do {
            let bookCases = try context.fetch(fetchRequest)
            return bookCases
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    //단어장 삭제
    func deleteBookCase(bookCase: NSManagedObject) {
        managedContext?.delete(bookCase)
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not delete: \(error.localizedDescription)")
        }
    }
    
    //단어장 수정
    func updateBookCase(_ bookCase: NSManagedObject, name: String, explain: String, word: String, meaning: String, image: Data, errorHandler: @escaping (Error) -> Void) {
        bookCase.setValue(name, forKey: "name")
        bookCase.setValue(explain, forKey: "explain")
        bookCase.setValue(word, forKey: "word")
        bookCase.setValue(meaning, forKey: "meaning")
        bookCase.setValue(image, forKey: "image")
        
        do {
            try managedContext?.save()
            print("코어데이터가 수정되었습니다.")
        } catch let error as NSError {
            errorHandler(error)
        }
    }
    
    //단어 저장
    func saveWord(word: String, definition: String, detail: String, pronunciation: String, synonym: String, antonym: String, to bookCase: String) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        
        let newWord = WordEntity(context: context)
        newWord.word = word
        newWord.definition = definition
        newWord.detail = detail
        newWord.pronunciation = pronunciation
        newWord.synonym = synonym
        newWord.antonym = antonym
        newWord.date = Date()
        newWord.memory = false
        
        newWord.bookCaseName = bookCase  // 관계 설정
        
        do {
            try context.save()
            print("단어가 저장되었습니다.")
        } catch {
            print("단어가 저장되지 않았습니다. 다시 시도해주세요. 오류: \(error)")
        }
    }
    
    
    //단어 삭제
    
    func deleteWord(word: WordEntity) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        context.delete(word)
        do {
            try context.save()
            print("단어가 삭제되었습니다.")
        } catch let error as NSError {
            print("Could not delete: \(error.localizedDescription)")
        }
    }
    
    //단어 불러오기
    func getWordList() -> [WordEntity] {
        var wordList: [WordEntity] = []
        
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return wordList
        }
        
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        
        do {
            wordList = try context.fetch(request)
        } catch {
            print("Failed to fetch word entities:", error)
        }
        return wordList
    }
    
    
    
    func getWordListFromCoreData(for date: Date) -> [WordEntity] {
        var wordList: [WordEntity] = []
        
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return wordList
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
        
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            wordList = try context.fetch(request)
        } catch {
            print("Failed to fetch word entities:", error)
        }
        return wordList
    }
    
    func hasData(for date: Date) -> Bool {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return false
        }
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", argumentArray: [startOfDay, endOfDay])
        
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        request.predicate = predicate
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Failed to fetch word entities:", error)
            return false
        }
    }
    
    func updateWordMemoryStatus(word: WordEntity, memory: Bool) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        word.memory = memory
        
        do {
            try context.save()
            print("단어의 외운 상태가 업데이트되었습니다.")
        } catch {
            print("단어의 외운 상태를 업데이트하지 못했습니다. 다시 시도해주세요. 오류: \(error)")
        }
    }
    
    func getSavedWordCount() -> Int {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return 0
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
        
        do {
            let savedWordCount = try context.count(for: fetchRequest)
            return savedWordCount
        } catch {
            print("Failed to fetch saved word count:", error)
            return 0
        }
    }
    
    func getLearnedWordCount() -> Int {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return 0
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordEntity")
        fetchRequest.predicate = NSPredicate(format: "memory == true")
        
        do {
            let learnedWordCount = try context.count(for: fetchRequest)
            return learnedWordCount
        } catch {
            print("Failed to fetch learned word count:", error)
            return 0
        }
    }
    
    func deleteWord(_ word: WordEntity) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        
        context.delete(word)
        
        do {
            try context.save()
            print("Word deleted successfully.")
        } catch {
            print("Failed to delete word: \(error)")
        }
    }
    
    func getSpecificData(query: String?, onError: @escaping (Error) -> Void) -> [WordEntity] {
        var array = [WordEntity]()
        guard let query = query else {
            return array
        }
        
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        let predicate = NSPredicate(format: "bookCaseName == %@", query)
        request.predicate = predicate
        
        do {
            array = try managedContext!.fetch(request)
        } catch {
            onError(error)
        }
        
        return array
    }
    
}


extension NSPersistentContainer {
    enum CopyPersistentStoreErrors: Error {
        case invalidDestination(String)
        case destinationError(String)
        case destinationNotRemoved(String)
        case copyStoreError(String)
        case invalidSource(String)
    }
    
    /// Restore backup persistent stores located in the directory referenced by `backupURL`.
    ///
    /// **Be very careful with this**. To restore a persistent store, the current persistent store must be removed from the container. When that happens, **all currently loaded Core Data objects** will become invalid. Using them after restoring will cause your app to crash. When calling this method you **must** ensure that you do not continue to use any previously fetched managed objects or existing fetched results controllers. **If this method does not throw, that does not mean your app is safe.** You need to take extra steps to prevent crashes. The details vary depending on the nature of your app.
    /// - Parameter backupURL: A file URL containing backup copies of all currently loaded persistent stores.
    /// - Throws: `CopyPersistentStoreError` in various situations.
    /// - Returns: Nothing. If no errors are thrown, the restore is complete.
    func restorePersistentStore(from backupURL: URL) throws -> Void {
        guard backupURL.isFileURL else {
            throw CopyPersistentStoreErrors.invalidSource("Backup URL must be a file URL")
        }
        
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: backupURL.path, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                throw CopyPersistentStoreErrors.invalidSource("Source URL must be a directory")
            }
        } else {
            throw CopyPersistentStoreErrors.invalidSource("Source URL must exist")
        }

        for persistentStore in persistentStoreCoordinator.persistentStores {
            guard let loadedStoreURL = persistentStore.url else {
                continue
            }
            let backupStoreURL = backupURL.appendingPathComponent(loadedStoreURL.lastPathComponent)
            guard FileManager.default.fileExists(atPath: backupStoreURL.path) else {
                throw CopyPersistentStoreErrors.invalidSource("Missing backup store for \(backupStoreURL)")
            }
            do {
                // Remove the existing persistent store first
                try persistentStoreCoordinator.remove(persistentStore)
            } catch {
                print("Error removing store: \(error)")
                throw CopyPersistentStoreErrors.copyStoreError("Could not remove persistent store before restore")
            }
            do {
                // Clear out the existing persistent store so that we'll have a clean slate for restoring.
                try persistentStoreCoordinator.destroyPersistentStore(at: loadedStoreURL, ofType: persistentStore.type, options: persistentStore.options)
                // Add the backup store at its current location
                let backupStore = try persistentStoreCoordinator.addPersistentStore(ofType: persistentStore.type, configurationName: persistentStore.configurationName, at: backupStoreURL, options: persistentStore.options)
                // Migrate the backup store to the non-backup location. This leaves the backup copy in place in case it's needed in the future, but backupStore won't be useful anymore.
                let restoredTemporaryStore = try persistentStoreCoordinator.migratePersistentStore(backupStore, to: loadedStoreURL, options: persistentStore.options, withType: persistentStore.type)
                print("Restored temp store: \(restoredTemporaryStore)")
            } catch {
                throw CopyPersistentStoreErrors.copyStoreError("Could not restore: \(error.localizedDescription)")
            }
        }
    }
    
    /// Copy all loaded persistent stores to a new directory. Each currently loaded file-based persistent store will be copied (including journal files, external binary storage, and anything else Core Data needs) into the destination directory to a persistent store with the same name and type as the existing store. In-memory stores, if any, are skipped.
    /// - Parameters:
    ///   - destinationURL: Destination for new persistent store files. Must be a file URL. If `overwriting` is `false` and `destinationURL` exists, it must be a directory.
    ///   - overwriting: If `true`, any existing copies of the persistent store will be replaced or updated. If `false`, existing copies will not be changed or remoted. When this is `false`, the destination persistent store file must not already exist.
    /// - Throws: `CopyPersistentStoreError`
    /// - Returns: Nothing. If no errors are thrown, all loaded persistent stores will be copied to the destination directory.
    func copyPersistentStores(to destinationURL: URL, overwriting: Bool = false) throws -> Void {
        guard destinationURL.isFileURL else {
            throw CopyPersistentStoreErrors.invalidDestination("Destination URL must be a file URL")
        }
        
        // If the destination exists and we aren't overwriting it, then it must be a directory. (If we are overwriting, we'll remove it anyway, so it doesn't matter whether it's a directory).
        var isDirectory: ObjCBool = false
        if !overwriting && FileManager.default.fileExists(atPath: destinationURL.path, isDirectory: &isDirectory) {
            if !isDirectory.boolValue {
                throw CopyPersistentStoreErrors.invalidDestination("Destination URL must be a directory")
            }
            // Don't check if destination stores exist in the destination dir, that comes later on a per-store basis.
        }
        // If we're overwriting, remove the destination.
        if overwriting && FileManager.default.fileExists(atPath: destinationURL.path) {
            do {
                try FileManager.default.removeItem(at: destinationURL)
            } catch {
                throw CopyPersistentStoreErrors.destinationNotRemoved("Can't overwrite destination at \(destinationURL)")
            }
        }

        // Create the destination directory
        do {
            try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw CopyPersistentStoreErrors.destinationError("Could not create destination directory at \(destinationURL)")
        }
        
        
        for persistentStoreDescription in persistentStoreDescriptions {
            guard let storeURL = persistentStoreDescription.url else {
                continue
            }
            guard persistentStoreDescription.type != NSInMemoryStoreType else {
                continue
            }
            let temporaryPSC = NSPersistentStoreCoordinator(managedObjectModel: persistentStoreCoordinator.managedObjectModel)
            let destinationStoreURL = destinationURL.appendingPathComponent(storeURL.lastPathComponent)

            if !overwriting && FileManager.default.fileExists(atPath: destinationStoreURL.path) {
                // If the destination exists, the migratePersistentStore call will update it in place. That's fine unless we're not overwriting.
                throw CopyPersistentStoreErrors.destinationError("Destination already exists at \(destinationStoreURL)")
            }
            do {
                let newStore = try temporaryPSC.addPersistentStore(ofType: persistentStoreDescription.type, configurationName: persistentStoreDescription.configuration, at: persistentStoreDescription.url, options: persistentStoreDescription.options)
                let _ = try temporaryPSC.migratePersistentStore(newStore, to: destinationStoreURL, options: persistentStoreDescription.options, withType: persistentStoreDescription.type)
            } catch {
                throw CopyPersistentStoreErrors.copyStoreError("\(error.localizedDescription)")
            }
        }
    }
}
