//
//  AddWordLogic.swift
//  Sparkle
//
//  Created by тимур on 23.01.2025.
//
import Foundation

// MARK: - Interactor Protocol
protocol AddWordBusinessLogic {
    func fetchResult(for word: String, mode: SearchMode)
    func addWord(_ word: WordModel)
}

// MARK: - Interactor Implementation
final class AddWordInteractor: AddWordBusinessLogic {
    var presenter: AddWordPresentationLogic?
    var mistralWorker: MistralWorkerProtocol?
    private let wordsStorage = WordsStorage.shared
    
    func fetchResult(for word: String, mode: SearchMode) {
        mistralWorker?.getWordModels(for: word, mode: mode) { result in
            switch result {
            case .success(let wordModels):
                DispatchQueue.main.async {
                    self.presenter?.presentResult(wordModels, mode: mode)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.presentError(error)
                }
            }
        }
    }

    func addWord(_ word: WordModel) {
        do {
            try wordsStorage.addWord(word)
            presenter?.presentWordSaved()
        } catch {
            presenter?.presentError(error)
        }
    }
}
