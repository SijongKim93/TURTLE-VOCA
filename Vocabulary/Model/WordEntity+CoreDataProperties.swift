//
//  WordEntity+CoreDataProperties.swift
//  Vocabulary
//
//  Created by t2023-m0049 on 5/17/24.
//
//

import Foundation
import CoreData


extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        return NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var word: String?
    @NSManaged public var definition: String?
    @NSManaged public var detail: String?
    @NSManaged public var pronunciation: String?
    @NSManaged public var synonym: String?
    @NSManaged public var antonym: String?
    @NSManaged public var date: Date?
    @NSManaged public var category: String?

}

extension WordEntity : Identifiable {

}
