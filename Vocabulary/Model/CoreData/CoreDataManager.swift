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
    
    // 영화 정보 저장
    func saveBookCase(name: String, explain: String, word: String, meaning: String, image: Data) {
        // CoreData에서 사용할 엔티티 생성
        let entity = NSEntityDescription.entity(forEntityName: "BookCase", in: managedContext)!
        let bookCase = NSManagedObject(entity: entity, insertInto: managedContext)
        
        bookCase.setValue(name, forKeyPath: "name")
        print("Name: \(name)")
        bookCase.setValue(explain, forKeyPath: "explain")
        bookCase.setValue(word, forKeyPath: "word")
        bookCase.setValue(meaning, forKeyPath: "meaning")
        bookCase.setValue(image, forKeyPath: "image")
        
        // 변경사항 저장
        do {
            try managedContext.save()
            print("코어데이터가 저장되었습니다.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // 영화 정보 가져오기
    func fetchBookCase() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookCase")
        
        do {
            let bookCases = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return bookCases
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    //저장된 영화 정보 삭제
    func deleteMovie(bookCase: NSManagedObject) {
        managedContext.delete(bookCase)
        do {
            try managedContext.save()
            print("예매가 취소되었습니다.")
        } catch let error as NSError {
            print("예매 취소 실패: \(error), \(error.userInfo)")
        }
    }
}
