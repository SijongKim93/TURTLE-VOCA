//
//  DummyEnglish.swift
//  Vocabulary
//
//  Created by 김시종 on 5/16/24.
//

import Foundation

class DummyEnglish {
    struct Word {
        let english: String
        let pronunciation: String
        let meaning: String
    }

    let dummyWords: [Word] = [
        Word(english: "apple", pronunciation: "[ˈæpəl]", meaning: "사과"),
        Word(english: "banana", pronunciation: "[bəˈnænə]", meaning: "바나나"),
        Word(english: "cat", pronunciation: "[kæt]", meaning: "고양이"),
        Word(english: "dog", pronunciation: "[dɔg]", meaning: "개"),
        Word(english: "elephant", pronunciation: "[ˈɛlɪfənt]", meaning: "코끼리"),
        Word(english: "fish", pronunciation: "[fɪʃ]", meaning: "물고기"),
        Word(english: "grape", pronunciation: "[greɪp]", meaning: "포도"),
        Word(english: "house", pronunciation: "[haʊs]", meaning: "집"),
        Word(english: "ice", pronunciation: "[aɪs]", meaning: "얼음"),
        Word(english: "juice", pronunciation: "[dʒuːs]", meaning: "주스")
    ]
}
