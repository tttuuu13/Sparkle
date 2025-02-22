//
//  AddWordPresenter.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
// MARK: - Presenter Protocol
protocol AddWordPresentationLogic {
    func presentResult(_ wordModels: [WordModel], mode: SearchMode)
    func presentError(_ error: Error)
    func presentWordSaved()
}

// MARK: - Presenter Implementation
final class AddWordPresenter: AddWordPresentationLogic {
    weak var viewController: AddWordDisplayLogic?
    
    func presentResult(_ wordModels: [WordModel], mode: SearchMode) {
        viewController?.displayResult(wordModels, mode: mode)
    }
    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    func presentWordSaved() {
        viewController?.displayWordSaved()
    }
}
