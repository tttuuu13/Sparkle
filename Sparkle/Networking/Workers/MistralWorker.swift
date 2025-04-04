//
//  MistralWorker.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//

import Foundation

protocol LLMWorkerProtocol {
    func getWordModels(for word: String, mode: CardFaceType, completion: @escaping (Result<[WordModel], Error>) -> Void)
    func getExampleSentence(for word: String, meaning: String, completion: @escaping (Result<String, Error>) -> Void)
    func getSmartShuffleWords(for words: [WordModel], amount: Int, completion: @escaping (Result<[WordModel], Error>) -> Void)
}

final class MistralWorker: LLMWorkerProtocol {
    static let shared: MistralWorker = MistralWorker()
    
    // MARK: - Constants
    private enum Constants {
        static let chatCompletionURL: String = "https://api.mistral.ai/v1/chat/completions"
    }

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
    func getWordModels(for word: String, mode:  CardFaceType, completion: @escaping (Result<[WordModel], Error>) -> Void) {
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
    
    func getExampleSentence(for word: String, meaning: String, completion: @escaping (Result<String, Error>) -> Void) {
        getCompletion(for: "Write a simple sentence using word '\(word)' in the meaning of '\(meaning)'. Make sure to return JUST ONE SENTENCE in following format: ['sentence']") { result in
            switch result {
            case .success(let response):
                let sentence = try? JSONDecoder().decode([String].self, from: response.data(using: .utf8)!).first ?? "Sentence cannot be generated("
                completion(.success(sentence ?? "Sentence cannot be generated("))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSmartShuffleWords(for words: [WordModel], amount: Int, completion: @escaping (Result<[WordModel], Error>) -> Void) {
        let wordsString = words.map { $0.word }.joined(separator: ", ")
        getCompletion(for: "Given this list of English words: [\(wordsString)]. Generate \(amount) ABSOLUTELY DIFFERENT in meaning to the given words, English words that are similar in difficulty level and complexity. Return them as a list of word models in JSON format: [{word: word, translation: translation to Russian, transcription: /transcription/, partOfSpeech: partOfSpeech, definition: definition in English}]") { result in
            switch result {
            case .success(let response):
                do {
                    let wordModels = try JSONDecoder().decode([WordModel].self, from: response.data(using: .utf8)!)
                    completion(.success(wordModels))
                } catch {
                    completion(.failure(MistralError.NoSmartShuffleWordsFound))
                }
            case .failure(_):
                completion(.failure(MistralError.NoSmartShuffleWordsFound))
            }
        }
    }
}

enum MistralError: Error {
    case NoTranslationsFound
    case NoDefinitionsFound
    case NoSmartShuffleWordsFound
}

final class LLMMockWorker: LLMWorkerProtocol {
    func getWordModels(for word: String, mode: CardFaceType, completion: @escaping (Result<[WordModel], any Error>) -> Void) {
        let words: [WordModel] = [
            WordModel(
                id: UUID(),
                word: "serendipity",
                partOfSpeech: "noun",
                transcription: "/ˌserənˈdɪpɪti/",
                translation: "случайная удача",
                definition: "the occurrence and development of events by chance in a happy or beneficial way"
            ),
            WordModel(
                id: UUID(),
                word: "ephemeral",
                partOfSpeech: "adjective",
                transcription: "/ɪˈfem(ə)rəl/",
                translation: "недолговечный",
                definition: "lasting for a very short time"
            ),
            WordModel(
                id: UUID(),
                word: "ubiquitous",
                partOfSpeech: "adjective",
                transcription: "/juːˈbɪkwɪtəs/",
                translation: "вездесущий",
                definition: "present, appearing, or found everywhere"
            ),
            WordModel(
                id: UUID(),
                word: "mellifluous",
                partOfSpeech: "adjective",
                transcription: "/məˈlɪfluəs/",
                translation: "медоточивый",
                definition: "sweet or musical; pleasant to hear"
            ),
            WordModel(
                id: UUID(),
                word: "paradigm",
                partOfSpeech: "noun",
                transcription: "/ˈparədʌɪm/",
                translation: "парадигма",
                definition: "a typical example or pattern of something"
            )
        ]
        completion(.success(words))
    }
    
    func getExampleSentence(for word: String, meaning: String, completion: @escaping (Result<String, any Error>) -> Void) {
        completion(.success("This is an example sentence."))
    }
    
    func getSmartShuffleWords(for words: [WordModel], amount: Int, completion: @escaping (Result<[WordModel], any Error>) -> Void) {
        let words = [
            WordModel(
                id: UUID(),
                word: "car",
                partOfSpeech: "adjective",
                transcription: "/məˈlɪfluəs/",
                translation: "медоточивый",
                definition: "sweet or musical; pleasant to hear"
            ),
            WordModel(
                id: UUID(),
                word: "road",
                partOfSpeech: "noun",
                transcription: "/ˈparədʌɪm/",
                translation: "парадигма",
                definition: "a typical example or pattern of something"
            )
        ]
        completion(.success(words))
    }
}
