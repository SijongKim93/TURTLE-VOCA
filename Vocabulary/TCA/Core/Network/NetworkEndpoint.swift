//
//  NetworkEndpoint.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/20/25.
//

import Foundation

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem]? { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

enum DeepLEndpoint: APIEndpoint {
    case translate(text: String, targetLang: String = "KO")
    
    var baseURL: String {
        return "https://api-free.deepl.com"
    }
    
    var path: String {
        switch self {
        case .translate:
            return "/v2/translate"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .translate:
            return .POST
        }
    }
    
    var headers: [String: String] {
        return [
            "Authorization": "DeepL-Auth-Key \(Secret.apiKey)"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .translate(let text, let targetLang):
            return [
                URLQueryItem(name: "text", value: text),
                URLQueryItem(name: "target_lang", value: targetLang)
            ]
        }
    }
}
