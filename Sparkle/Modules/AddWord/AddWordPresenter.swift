//
//  AddWordPresenter.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
// MARK: - Presenter Protocol
protocol AddWordPresenterProtocol {
    func presentTranslations(_ translations: [String])
    func presentError(_ message: String)
}

// MARK: - Presenter Implementation
final class AddWordPresenter: AddWordPresenterProtocol {
    weak var view: AddWordPresenterOutput?
    
    func presentTranslations(_ translations: [String]) {
        view?.displayTranslations(translations)
    }
    func presentError(_ message: String) {}
}
