//
//  MistralWorker.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//

import Foundation

protocol MistralWorkerProtocol {
    func getWordModels(for word: String, mode: SearchMode, completion: @escaping (Result<[WordModel], Error>) -> Void)
    func getExampleSentence(for wordModel: WordModel, completion: @escaping (Result<String, Error>) -> Void)
}

final class MistralWorker: MistralWorkerProtocol {
    static let shared: MistralWorker = MistralWorker()

    // MARK: - Private Methods
    private func getCompletion(for message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: Constants.chatCompletionURL) else {
            completion(.failure(NetworkError.InvalidURL))
            return
        }
        
        let parameters: [String: Any] = [
            "model": "open-mistral-nemo",
            "messages": [
                [
                    "role": "user",
                    "content": message
                ]
            ],
            "response_format": [
                "type": "json_object"
            ]
        ]
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: parameters)
            
            let headers = ["Authorization": "Bearer e4Yb7x4AXmoXEdauOnjkVA42qpPWHpdV",
                           "Content-Type": "application/json"]
            
            NetworkManager.shared.request(url: url, method: "POST", params: postData, headers: headers) { (result: Result<MistralResponse, Error>) in
                switch result {
                case .success(let response):
                    if let content = response.choices.first?.message.content {
                        completion(.success(content))
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

    // MARK: - Public Methods
    func getWordModels(for word: String, mode: SearchMode, completion: @escaping (Result<[WordModel], Error>) -> Void) {
        getCompletion(for: "Given the word '\(word)'. Return a list of one or more (if word has multiple \(mode == .translation ? "translations" : "definitions")) word models in JSON with following format: [{word: word, translation: translation to Russian, transcription: /transcription of original word/, partOfSpeech: partOfSpeech, definition: definition in english}]") { result in
            switch result {
            case .success(let response):
                do {
                    let wordModels = try JSONDecoder().decode([WordModel].self, from: response.data(using: .utf8)!)
                    completion(.success(wordModels))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getExampleSentence(for wordModel: WordModel, completion: @escaping (Result<String, Error>) -> Void) {
        getCompletion(for: "Write a short sentence using word '\(wordModel.word)' in the meaning of '\(wordModel.definition)'") { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private enum Constants {
        static let chatCompletionURL: String = "https://api.mistral.ai/v1/chat/completions"
    }
}

enum MistralError: Error {
    case NoTranslationsFound
    case NoDefinitionsFound
}
