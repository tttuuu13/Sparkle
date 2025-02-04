//
//  MistralWorker.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//

import Foundation


final class MistralWorker {
    func getTranslations(for word: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: Constants.chatComplitionURL) else {
            completion(.failure(NetworkError.InvalidURL))
            return
        }
        
        let parameters: [String: Any] = [
            "model": "mistral-large-latest",
            "messages": [
                [
                    "role": "user",
                    "content": "Translate word '\(word)\' to Russian. Give multiple translations (if present). Answer in ONLY JSON with following format: {translations: []} if no translations found return empty list"
                ]
            ],
            "response_format": [
                "type": "json_object"
            ]
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters)
            
            let headers = ["Authorization": "HIDDEN",
                           "Content-Type": "application/json"]
            
            NetworkManager.shared.request(url: url, method: "POST", params: postData, headers: headers) { (result: Result<MistralTranslationResponse, Error>) in
                switch result {
                case .success(let response):
                    if let content = response.choices.first?.message.content {
                        do {
                            let translations = try JSONDecoder().decode(TranslationResponse.self, from: content.data(using: .utf8)!).translations
                            if translations.isEmpty {
                                completion(.failure(MistralError.NoTranslationsFound))
                            } else {
                                completion(.success(translations))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(MistralError.NoTranslationsFound))
                    }
                case .failure(let error):
                    print("error: \(error)")
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    private enum Constants {
        static let chatComplitionURL: String = "https://api.mistral.ai/v1/chat/completions"
    }
}

enum MistralError: Error {
    case NoTranslationsFound
}
