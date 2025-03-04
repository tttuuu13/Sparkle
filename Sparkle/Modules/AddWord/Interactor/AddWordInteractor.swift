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
    private var wordModels: [WordModel] = []
    private var wordsInitialCount: Int = 0
    private let wordsStorage = WordsStorage.shared
    
    func fetchResult(for request: AddWordModels.Request.Search) {
        mistralWorker?.getWordModels(for: request.word, mode: request.mode) { result in
            switch result {
            case .success(let wordModels):
                DispatchQueue.main.async {
                    self.wordModels = wordModels
                    self.wordsInitialCount = wordModels.count
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

extension AddWordInteractor: CardStackViewDataSource {
    func numberOfCards(in cardStack: CardStackView) -> Int {
        wordModels.count
    }
    
    func cardStack(_ cardStack: CardStackView, wordModelAt index: Int) -> WordModel {
        wordModels[index]
    }
    
    
}
