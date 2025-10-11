//
//  BookCase+CoreDataClass.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/23/24.
//
//

import Foundation
import CoreData


public class BookCase: NSManagedObject {

}

// MARK: - Equatable
extension BookCase {
    public static func == (lhs: BookCase, rhs: BookCase) -> Bool {
        return lhs.objectID == rhs.objectID
    }
}
