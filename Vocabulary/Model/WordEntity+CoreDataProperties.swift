//
//  WordEntity+CoreDataProperties.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/23/24.
//
//

import Foundation
import CoreData


extension WordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordEntity> {
        return NSFetchRequest<WordEntity>(entityName: "WordEntity")
    }

    @NSManaged public var antonym: String?
    @NSManaged public var bookCaseName: String?
    @NSManaged public var date: Date?
    @NSManaged public var definition: String?
    @NSManaged public var detail: String?
    @NSManaged public var memory: Bool
    @NSManaged public var pronunciation: String?
    @NSManaged public var synonym: String?
    @NSManaged public var word: String?
    @NSManaged public var uuid: String?
    @NSManaged public var bookCase: BookCase?

}

extension WordEntity : Identifiable {

}
