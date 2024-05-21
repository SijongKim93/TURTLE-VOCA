//
//  NetworkManager.swift
//  Vocabulary
//
//  Created by Dongik Song on 5/21/24.
//

import Foundation
import Combine

class NetworkManager {
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchRequest (query: String) -> Future<[Translation], Error> {
        
        return Future<[Translation], Error> { [weak self] promise in
            
            let url = "https://api-free.deepl.com/v2/translate"
            let header = ["Authorization" : "DeepL-Auth-Key \(Secret.apiKey)"]
            let component = [URLQueryItem(name: "text", value: query), URLQueryItem(name: "target_lang", value: "KO")]
            var urlComponent = URLComponents(string: url)
            urlComponent?.queryItems = component

            guard let urlRequest = urlComponent?.url else {
                return
            }
            var request = URLRequest(url: urlRequest)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = header
            let session = URLSession(configuration: .default)
            
            session.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: TranslatedModel.self, decoder: JSONDecoder())
                .map({ model in
                    return model.translations
                })
                .replaceError(with: [])
                .sink { data in
                    promise(.success(data))
                }.store(in: &self!.cancellables)
        }
    }
    
    // before
    func fetchRequest1 (query: String, complete: @escaping (Result<TranslatedModel,Error>) -> Void) {
            
            let url = "https://api-free.deepl.com/v2/translate"
            let header = ["Authorization" : "DeepL-Auth-Key \(Secret.apiKey)"]
            let component = [URLQueryItem(name: "text", value: query), URLQueryItem(name: "target_lang", value: "KO")]
            var urlComponent = URLComponents(string: url)
            urlComponent?.queryItems = component
            
            if let urlRequest = urlComponent?.url {
                var request = URLRequest(url: urlRequest)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = header
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: request) { data, response, error in
                    if let e = error {
                        complete(.failure(e))
                    }
                    
                    if let safeData = data {
                        if let decodedData = try? JSONDecoder().decode(TranslatedModel.self, from: safeData) {
                            complete(.success(decodedData))
                        }
                    }
                }
                task.resume()
            }
            
        }
}
