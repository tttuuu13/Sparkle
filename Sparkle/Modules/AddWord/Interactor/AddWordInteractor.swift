//
//  AddWordLogic.swift
//  Sparkle
//
//  Created by тимур on 23.01.2025.
//
import Foundation

// MARK: - Interactor Protocol
protocol AddWordBusinessLogic {
    func fetchResult(for request: AddWordModels.Request.Search)
    func addWord(_ request: AddWordModels.Request.Add)
}

// MARK: - Interactor Implementation
final class AddWordInteractor: AddWordBusinessLogic {
    var presenter: AddWordPresentationLogic?
    var mistralWorker: MistralWorkerProtocol?
    private let wordsStorage = WordsStorage.shared
    
    func fetchResult(for request: AddWordModels.Request.Search) {
        mistralWorker?.getWordModels(for: request.word, mode: request.mode) { result in
            switch result {
            case .success(let wordModels):
                DispatchQueue.main.async {
                    let response = AddWordModels.Response.SearchResult(wordModels: wordModels, mode: request.mode)
                    self.presenter?.presentResult(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.presentError(error)
                }
            }
        }
    }

    func addWord(_ request: AddWordModels.Request.Add) {
        do {
            try wordsStorage.addWord(request.word)
            presenter?.presentWordSaved()
        } catch {
            presenter?.presentError(error)
        }
    }
}
