//
//  WordEntity+CoreDataClass.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/23/24.
//
//

import Foundation
import CoreData

@objc(WordEntity)
public class WordEntity: NSManagedObject {

}

// MARK: - Equatable
extension WordEntity {
    public static func == (lhs: WordEntity, rhs: WordEntity) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}
