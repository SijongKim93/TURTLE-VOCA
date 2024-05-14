//
//  DummyGenerator.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/14/24.
//

import Foundation

class DummyGenerator {
    
    func makeDummy () -> [DummyModel] {
        var array = [DummyModel]()
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for _ in 0...19 {
            let int = (1...5).randomElement()!
            let secondInt = (1...5).randomElement()!
            let word = String((0..<int).map{ _ in letters.randomElement()! })
            let meaning = String((0..<secondInt).map{ _ in letters.randomElement()! })
            let dummy = DummyModel(words: word, meaning: meaning)
            array.append(dummy)
        }
        return array
    }
    
}
