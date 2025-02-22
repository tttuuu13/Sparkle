//
//  DictionaryPresenter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

protocol DictionaryPresentationLogic {
    func presentWords(_ response: DictionaryModels.FetchWords.Response)
    func presentError(_ error: Error)
}

final class DictionaryPresenter: DictionaryPresentationLogic {
    weak var viewController: DictionaryDisplayLogic?

    func presentWords(_ response: DictionaryModels.FetchWords.Response) {
        let viewModel = DictionaryModels.FetchWords.ViewModel(words: response.words)
        viewController?.displayWords(viewModel)
    }

    func presentError(_ error: any Error) {
        
    }
}
