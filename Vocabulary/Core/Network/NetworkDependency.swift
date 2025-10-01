//
//  NetworkDependency.swift
//  TURTLEVOCA
//
//  Created by 김시종 on 9/20/25.
//

import ComposableArchitecture
import Foundation
import Combine

@DependencyClient
struct NetworkDependency {
    var translateText: @Sendable (String) async throws -> [Translation] = { _ in [] }
    var request: @Sendable (APIEndpoint) async throws -> Data = { _ in Data() }
}

extension NetworkDependency: DependencyKey {
    static let liveValue = Self(
        translateText: { text in
            let endpoint = DeepLEndpoint.translate(text: text, targetLang: "KO")
            let data = try await performRequest(endpoint: endpoint)
            let model = try JSONDecoder().decode(TranslatedModel.self, from: data)
            return model.translations
        },
        request: { endpoint in
            try await performRequest(endpoint: endpoint)
        }
    )
    
    static let previewValue = Self(
        translateText: { text in
            try await Task.sleep(nanoseconds: 500_000_000)
            return [Translation(text: "\(text) → 번역된 텍스트")]
        },
        
        request: { endpoint in
            try await Task.sleep(nanoseconds: 500_000_000)
            return Data("{\"translations\":[{\"text\":\"프리뷰 번역\"}]}".utf8)
        }
    )
}

extension DependencyValues {
    var networkDependency: NetworkDependency {
        get { self[NetworkDependency.self] }
        set { self[NetworkDependency.self] = newValue }
    }
}

private func performRequest(endpoint: APIEndpoint) async throws -> Data {
    guard var urlComponents = URLComponents(string: endpoint.baseURL + endpoint.path) else {
        throw NetworkError.invalidURL
    }
    
    if let queryItems = endpoint.queryItems {
        urlComponents.queryItems = queryItems
    }
    
    guard let url = urlComponents.url else {
        throw NetworkError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = endpoint.method.rawValue
    
    for (key, value) in endpoint.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 400...499:
                throw NetworkError.serverError(httpResponse.statusCode)
            case 500...599:
                throw NetworkError.serverError(httpResponse.statusCode)
            default:
                throw NetworkError.unknown
            }
        }
        
        return data
    } catch let error as NetworkError {
        throw error
    } catch {
        throw NetworkError.unknown
    }
}
