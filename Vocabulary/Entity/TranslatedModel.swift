//
//  TranslatedModel.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/21/24.
//

import Foundation

struct TranslatedModel: Codable, Hashable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable, Hashable {
    let text: String
}

