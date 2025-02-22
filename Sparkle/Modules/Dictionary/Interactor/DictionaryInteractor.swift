//
//  DictionaryInteractor.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

protocol DictionaryBusinessLogic {
    func fetchWords(request: DictionaryModels.FetchWords.Request)
    func deleteWord(request: DictionaryModels.DeleteWord.Request)
}

class DictionaryInteractor: DictionaryBusinessLogic {
    var presenter: DictionaryPresentationLogic?
    private let wordsStorage = WordsStorage.shared

    func fetchWords(request: DictionaryModels.FetchWords.Request) {
        do {
            let words = try wordsStorage.getWords()
            let response = DictionaryModels.FetchWords.Response(words: words)
            presenter?.presentWords(response)
        } catch {
            presenter?.presentError(error)
        }
    }

    func deleteWord(request: DictionaryModels.DeleteWord.Request) {
        do {
            try wordsStorage.deleteWord(request.word)
        } catch {
            presenter?.presentError(error)
        }
    }
}