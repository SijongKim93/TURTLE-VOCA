//
//  DateFormatter+Extension.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/23/25.
//

import Foundation

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
