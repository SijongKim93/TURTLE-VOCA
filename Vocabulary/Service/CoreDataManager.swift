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
