//
//  AddWordPresenter.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
// MARK: - Presenter Protocol
protocol AddWordPresenterProtocol {
    func presentTranslations(_ translations: [TranslationModel])
    func presentDefinitions(_ definitions: [DefinitionModel])
    func presentError(_ error: Error)
}

// MARK: - Presenter Implementation
final class AddWordPresenter: AddWordPresenterProtocol {
    weak var view: AddWordPresenterOutput?
    
    func presentTranslations(_ translations: [TranslationModel]) {
        var updatedTranslations = translations
        for i in 0..<translations.count {
            updatedTranslations[i].counter = Counter(current: i + 1, total: translations.count)
        }
        view?.displayTranslations(updatedTranslations)
    }
    
    func presentDefinitions(_ definitions: [DefinitionModel]) {
        var updatedDefinitions = definitions
        for i in 0..<definitions.count {
            updatedDefinitions[i].counter = Counter(current: i + 1, total: definitions.count)
        }
        
        view?.displayDefinitions(updatedDefinitions)
    }
    
    func presentError(_ error: Error) {
        view?.displayError(error)
    }
}
