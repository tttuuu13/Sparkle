//
//  DictionaryPresenter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

protocol DictionaryPresentationLogic {
    func presentWords(_ response: DictionaryModels.LoadWords.Response)
    func presentDeleteWord(_ response: DictionaryModels.DeleteWord.Response)
    func presentError(_ error: Error)
}

final class DictionaryPresenter: DictionaryPresentationLogic {
    weak var viewController: DictionaryDisplayLogic?

    func presentWords(_ response: DictionaryModels.LoadWords.Response) {
        viewController?.displayWords(DictionaryModels.LoadWords.ViewModel())
    }
    
    func presentDeleteWord(_ response: DictionaryModels.DeleteWord.Response) {
        viewController?.displayDeleteWord(DictionaryModels.DeleteWord.ViewModel(indexPath: response.indexPath))
    }

    func presentError(_ error: any Error) {
        
    }
}
