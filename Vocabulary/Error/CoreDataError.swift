//
//  CoreDataError.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/18/25.
//

import Foundation

enum CoreDataError: LocalizedError {
    case contextNotAvailable
    case invalidDate
    case fetchFailed(Error)
    case saveFailed(Error)
    case batchUpdateFailed(Error)
    case batchDeleteFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .contextNotAvailable:
            return "CoreData context를 사용할 수 없습니다."
        case .invalidDate:
            return "날짜가 유효하지 않습니다."
        case .fetchFailed(let error):
            return "데이터 조회에 실패했습니다: \(error)"
        case .saveFailed(let error):
            return "데이터 저장에 실패했습니다: \(error.localizedDescription)"
        case .batchUpdateFailed(let error):
            return "일괄 업데이트에 실패했습니다: \(error.localizedDescription)"
        case .batchDeleteFailed(let error):
            return "일괄 삭제에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
