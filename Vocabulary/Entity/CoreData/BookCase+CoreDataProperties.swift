//
//  BookCase+CoreDataProperties.swift
//  Vocabulary
//
//  Created by Luz on 5/17/24.
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

}

extension BookCase : Identifiable {

}
