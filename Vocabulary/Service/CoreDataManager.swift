//
//  CoreDataManager.swift
//  Vocabulary
//
//  Created by 김한빛 on 5/16/24.
//
import Foundation
import UIKit
import CoreData
import CloudKit

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
    func fetchBookCase(errorHandler: @escaping (Error) -> Void) -> [NSManagedObject] {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return []
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookCase")
        do {
            let bookCases = try context.fetch(fetchRequest)
            return bookCases
        } catch let error as NSError {
            errorHandler(error)
            return []
        }
    }
    
    //단어장 삭제
    func deleteBookCase(bookCase: NSManagedObject, errorHandler: @escaping (Error) -> Void) {
        managedContext?.delete(bookCase)
        do {
            try managedContext?.save()
        } catch let error as NSError {
            errorHandler(error)
        }
    }
    
    //단어장 수정
    func updateBookCase(_ bookCase: BookCase, name: String, explain: String, word: String, meaning: String, image: Data, errorHandler: @escaping (Error) -> Void) {
        bookCase.setValue(name, forKey: "name")
        bookCase.setValue(explain, forKey: "explain")
        bookCase.setValue(word, forKey: "word")
        bookCase.setValue(meaning, forKey: "meaning")
        bookCase.setValue(image, forKey: "image")
        
        if let words = bookCase.words as? Set<WordEntity> {
            for word in words {
                word.bookCaseName = name
            }
        }
        
        do {
            try managedContext?.save()
            print("코어데이터가 수정되었습니다.")
        } catch let error as NSError {
            errorHandler(error)
        }
    }
    
    //단어 저장
    func saveWord(word: String, definition: String, detail: String, pronunciation: String, synonym: String, antonym: String, to bookCase: BookCase, to bookCaseName: String) {
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
        
        newWord.bookCase = bookCase
        newWord.bookCaseName = bookCase.name
        
        do {
            try context.save()
            print("단어가 저장되었습니다.")
        } catch {
            print("단어가 저장되지 않았습니다. 다시 시도해주세요. 오류: \(error)")
        }
    }
    
    //단어 수정
    func updateVoca(_ bookCase: NSManagedObject, name: String, explain: String, word: String, meaning: String, image: Data, errorHandler: @escaping (Error) -> Void) {
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

// MARK: - Coredata to Cloud
extension CoreDataManager {
    func syncData() {
        syncEntity(BookCase.self, recordType: "BookCase")
        syncEntity(WordEntity.self, recordType: "WordEntity")
    }
    
    func syncEntity<T: NSManagedObject>(_ entityType: T.Type, recordType: String) {
        let fetchRequest = T.fetchRequest()
        
        do {
            let results = try managedContext!.fetch(fetchRequest)
            for object in results {
                // Ensure the object has a UUID
                if let bookCase = object as? BookCase, bookCase.uuid == nil {
                    bookCase.uuid = UUID().uuidString
                } else if let wordEntity = object as? WordEntity, wordEntity.uuid == nil {
                    wordEntity.uuid = UUID().uuidString
                }
                saveToCloudKit(object as! NSManagedObject, recordType: recordType)
            }
        } catch {
            print("Failed to fetch data from Core Data: \(error)")
        }
    }
    
    func saveToCloudKit(_ object: NSManagedObject, recordType: String) {
        let database = CKContainer(identifier: "iCloud.com.teamproject.Vocabularytest").privateCloudDatabase
        var recordID: CKRecord.ID
        
        // Generate a unique identifier for the record
        if let bookCase = object as? BookCase {
            recordID = CKRecord.ID(recordName: bookCase.uuid ?? UUID().uuidString)
        } else if let wordEntity = object as? WordEntity {
            recordID = CKRecord.ID(recordName: wordEntity.uuid ?? UUID().uuidString)
        } else {
            print("Unknown object type")
            return
        }
        
        // Check if the record already exists
        database.fetch(withRecordID: recordID) { fetchedRecord, error in
            if let fetchedRecord = fetchedRecord {
                // Record already exists, update it if necessary
                self.updateRecord(fetchedRecord, withObject: object, recordType: recordType, database: database)
            } else if let ckError = error as? CKError, ckError.code == .unknownItem {
                // Record does not exist, create a new one
                let newRecord = CKRecord(recordType: recordType, recordID: recordID)
                self.populateRecord(newRecord, withObject: object, recordType: recordType)
                self.saveRecord(newRecord, toDatabase: database)
            } else {
                print("Error fetching record from CloudKit: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func updateRecord(_ record: CKRecord, withObject object: NSManagedObject, recordType: String, database: CKDatabase) {
        populateRecord(record, withObject: object, recordType: recordType)
        saveRecord(record, toDatabase: database)
    }
    
    func populateRecord(_ record: CKRecord, withObject object: NSManagedObject, recordType: String) {
        // Set record fields based on entity type
        if let bookCase = object as? BookCase {
            record["name"] = bookCase.name as CKRecordValue?
            record["explain"] = bookCase.explain as CKRecordValue?
            record["meaning"] = bookCase.meaning as CKRecordValue?
            record["image"] = bookCase.image as CKRecordValue?
            record["word"] = bookCase.word as CKRecordValue?
        } else if let wordEntity = object as? WordEntity {
            record["antonym"] = wordEntity.antonym as CKRecordValue?
            record["bookCaseName"] = wordEntity.bookCaseName as CKRecordValue?
            record["date"] = wordEntity.date as CKRecordValue?
            record["definition"] = wordEntity.definition as CKRecordValue?
            record["detail"] = wordEntity.detail as CKRecordValue?
            record["memory"] = wordEntity.memory as CKRecordValue?
            record["pronunciation"] = wordEntity.pronunciation as CKRecordValue?
            record["synonym"] = wordEntity.synonym as CKRecordValue?
            record["word"] = wordEntity.word as CKRecordValue?
        }
    }
    
    func saveRecord(_ record: CKRecord, toDatabase database: CKDatabase) {
        database.save(record) { savedRecord, error in
            if let error = error {
                print("Error saving record to CloudKit: \(error)")
            } else {
                print("\(record.recordType) saved to CloudKit successfully")
            }
        }
    }
}

// MARK: - Cloud to Coredata

extension CoreDataManager {
    func syncDataFromCloudKit() {
        syncEntityFromCloudKit(recordType: "BookCase", entityType: BookCase.self)
        syncEntityFromCloudKit(recordType: "WordEntity", entityType: WordEntity.self)
    }

    func syncEntityFromCloudKit<T: NSManagedObject>(recordType: String, entityType: T.Type) {
        let database = CKContainer(identifier: "iCloud.com.teamproject.Vocabularytest").publicCloudDatabase
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                print("Error fetching records from CloudKit: \(error)")
                return
            }
            
            guard let records = records else { return }
            
            let context = self.managedContext!
            
            context.perform {
                for record in records {
                    self.updateOrInsertRecord(record, entityType: entityType, context: context)
                }
                
                do {
                    try context.save()
                    print("\(recordType) records synced to Core Data successfully")
                } catch {
                    print("Error saving context: \(error)")
                }
            }
        }
    }

    func updateOrInsertRecord<T: NSManagedObject>(_ record: CKRecord, entityType: T.Type, context: NSManagedObjectContext) {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", record.recordID.recordName)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let existingObject = results.first as? T {
                populateManagedObject(existingObject, withRecord: record)
            } else {
                let newObject = T(context: context)
                populateManagedObject(newObject, withRecord: record)
            }
        } catch {
            print("Error fetching object: \(error)")
        }
    }

    func populateManagedObject(_ object: NSManagedObject, withRecord record: CKRecord) {
        if let bookCase = object as? BookCase {
            bookCase.uuid = record.recordID.recordName
            bookCase.name = record["name"] as? String
            bookCase.explain = record["explain"] as? String
            bookCase.meaning = record["meaning"] as? String
            bookCase.image = record["image"] as? Data
            bookCase.word = record["word"] as? String
        } else if let wordEntity = object as? WordEntity {
            wordEntity.uuid = record.recordID.recordName
            wordEntity.antonym = record["antonym"] as? String
            wordEntity.bookCaseName = record["bookCaseName"] as? String
            wordEntity.date = record["date"] as? Date
            wordEntity.definition = record["definition"] as? String
            wordEntity.detail = record["detail"] as? String
            wordEntity.memory = (record["memory"] as? Bool)!
            wordEntity.pronunciation = record["pronunciation"] as? String
            wordEntity.synonym = record["synonym"] as? String
            wordEntity.word = record["word"] as? String
        }
    }
}
