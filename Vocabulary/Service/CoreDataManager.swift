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
    private init() { }
    
    // AppDelegate에 접근하기 위한 프로퍼티
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not accessible.")
        }
        return appDelegate
    }
    
    // CoreData의 관리 객체 컨텍스트
    private var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - methods

    func saveBookCase(name: String, explain: String, word: String, meaning: String, image: Data) {
        let entity = NSEntityDescription.entity(forEntityName: "BookCase", in: managedContext)!
        let bookCase = NSManagedObject(entity: entity, insertInto: managedContext)

        bookCase.setValue(name, forKey: "name")
        bookCase.setValue(explain, forKey: "explain")
        bookCase.setValue(word, forKey: "word")
        bookCase.setValue(meaning, forKey: "meaning")
        bookCase.setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
            print("코어데이터가 저장되었습니다.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchBookCase() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookCase")

        do {
            let bookCases = try managedContext.fetch(fetchRequest)
            return bookCases
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
}
