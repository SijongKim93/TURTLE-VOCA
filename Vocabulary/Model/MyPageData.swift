//
//  MyPageData.swift
//  Vocabulary
//
//  Created by 김시종 on 5/16/24.
//

import Foundation


class MyPageData {
    var items: [(title: String, imageName: String)] = [
        ("리뷰 작성", "square.and.pencil"),
        ("앱 추천하기", "square.and.arrow.up"),
        ("문의하기", "bubble"),
        ("로그인", "lock"),
        ("iCloud에 단어 저장하기", "externaldrive.badge.icloud"),
        ("iCloud에서 불러오기", "externaldrive.badge.icloud")
    ]
    
    func updateLoginStatus() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn {
            items[3] = ("로그아웃", "lock")
        } else {
            items[3] = ("로그인", "lock")
        }
    }
}
