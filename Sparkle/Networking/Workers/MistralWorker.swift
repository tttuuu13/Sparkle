//
//  MistralWorker.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//

import Foundation


final class MistralWorker {
    static let shared = MistralWorker()
    
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
    
    func getTranslations(for word: String, completion: @escaping (Result<[TranslationModel], Error>) -> Void) {
        getCompletion(
            for: "Translate word '\(word)\' to Russian. Give multiple translations (if present). Answer in ONLY JSON with following format: {transcription: '/transcription/', translations: []} if no translations found return empty list"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let responseModel = try JSONDecoder().decode(TranslationResponse.self, from: response.data(using: .utf8)!)
                    let translationModels = responseModel.translations.map { TranslationModel(text: $0, transcription: responseModel.transcription) }
                    if translationModels.isEmpty {
                        completion(.failure(MistralError.NoTranslationsFound))
                    } else {
                        completion(.success(translationModels))
                    }
                } catch {
                    completion(.failure(error))
                }
            case(.failure(let error)):
                completion(.failure(error))
            }
        }
    }
    
    func getDefinitions(for word: String, completion: @escaping (Result<[DefinitionModel], Error>) -> Void) {
        getCompletion(
            for: "Give me a list of one or more definitions of word '\(word)'. For each definition choose a word class it represents from this list: [noun, verb, adjective, adverb, pronoun, preposition, conjunction, interjection, numeral, article, determiner]. Answer in ONLY JSON with following format: {definitions: [{wordClass: noun, definition: text}]} if no definitions found return empty list"
        ) { result in
            switch result {
            case .success(let response):
                do {
                    let definitions = try JSONDecoder().decode(DefinitionResponse.self, from: response.data(using: .utf8)!).definitions
                    let definitionModels = definitions.map { DefinitionModel(word:word, wordClass: $0.wordClass, definition: $0.definition) }
                    if definitionModels.isEmpty {
                        completion(.failure(MistralError.NoTranslationsFound))
                    } else {
                        completion(.success(definitionModels))
                    }
                } catch {
                    completion(.failure(error))
                }
            case(.failure(let error)):
                completion(.failure(error))
            }
        }
    }
    
    func getExampleSentence(for definition: DefinitionModel, completion: @escaping (Result<String, Error>) -> Void) {
        getCompletion(for: "Write a short sentence using word '\(definition.word)' in the meaning of '\(definition.definition)'") { result in
            print(result)
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
