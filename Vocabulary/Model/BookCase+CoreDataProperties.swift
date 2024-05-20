//
//  BookCase+CoreDataProperties.swift
//  Vocabulary
//
//  Created by Luz on 5/20/24.
//
//

import Foundation
import CoreData


extension BookCase {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookCase> {
        return NSFetchRequest<BookCase>(entityName: "BookCase")
    }

    @NSManaged public var explain: String?
    @NSManaged public var image: Data?
    @NSManaged public var meaning: String?
    @NSManaged public var name: String?
    @NSManaged public var word: String?
    @NSManaged public var words: NSSet?

}

// MARK: Generated accessors for words
extension BookCase {

    @objc(addWordsObject:)
    @NSManaged public func addToWords(_ value: WordEntity)

    @objc(removeWordsObject:)
    @NSManaged public func removeFromWords(_ value: WordEntity)

    @objc(addWords:)
    @NSManaged public func addToWords(_ values: NSSet)

    @objc(removeWords:)
    @NSManaged public func removeFromWords(_ values: NSSet)

}

extension BookCase : Identifiable {

}
