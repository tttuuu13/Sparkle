//
//  AddWordPresenter.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
// MARK: - Presenter Protocol
protocol AddWordPresentationLogic {
    func presentResult(_ response: AddWordModels.Response.SearchResult)
    func presentError(_ error: Error)
    func presentWordSaved()
}

// MARK: - Presenter Implementation
final class AddWordPresenter: AddWordPresentationLogic {
    weak var viewController: AddWordDisplayLogic?
    
    func presentResult(_ response: AddWordModels.Response.SearchResult) {
        let viewModel = AddWordModels.ViewModel.SearchResult(wordModels: response.wordModels, mode: response.mode)
        viewController?.displayResult(viewModel)
    }
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    func presentWordSaved() {
        viewController?.displayWordSaved()
    }
}
