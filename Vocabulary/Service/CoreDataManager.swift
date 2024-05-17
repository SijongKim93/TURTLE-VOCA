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
    
    func saveBookCase(name: String, explain: String, word: String, meaning: String, image: Data) {
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return
        }
        
        let entity = NSEntityDescription.entity(forEntityName: "BookCase", in: context)!
        let bookCase = NSManagedObject(entity: entity, insertInto: context)
        do {
            try context.save()
            print("코어데이터가 저장되었습니다.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
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
    
    func saveWord(word: String, definition: String, detail: String, pronunciation: String, synonym: String, antonym: String) {
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
        
        do {
            try context.save()
            print("단어가 저장되었습니다.")
        } catch {
            print("단어가 저장되지 않았습니다. 다시 시도해주세요. 오류: \(error)")
        }
    }
    
    func getWordListFromCoreData() -> [WordEntity] {
        var wordList: [WordEntity] = []
        
        guard let context = managedContext else {
            print("Error: managedContext is nil")
            return wordList
        }
        
        let request: NSFetchRequest<WordEntity> = WordEntity.fetchRequest()
        let dateOrder = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateOrder]
        
        do {
            wordList = try context.fetch(request)
        } catch {
            print("Failed to fetch word entities:", error)
        }
        return wordList
    }
}
