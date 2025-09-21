//
//  NetworkError.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/20/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .noData:
            return "유효한 데이터가 없습니다."
        case .decodingError:
            return "데이터 파싱에 실패했습니다."
        case .serverError(let error):
            return "서버에 에러가 발생했습니다. \(error)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
