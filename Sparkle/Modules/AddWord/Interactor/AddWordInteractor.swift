//
//  AddWordLogic.swift
//  Sparkle
//
//  Created by тимур on 23.01.2025.
//
import Foundation

// MARK: - Interactor Protocol
protocol AddWordInteractorProtocol {
    func fetchTranslations(for word: String)
    func fetchDefinitions(for word: String)
}

// MARK: - Interactor Implementation
final class AddWordInteractor: AddWordInteractorProtocol {
    var presenter: AddWordPresenterProtocol?
    var textToSpeechWorker: TextToSpeechWorker?
    
    func fetchTranslations(for word: String) {
        MistralWorker.shared.getTranslations(for: word) { result in
            switch result {
            case .success(let translations):
                DispatchQueue.main.async {
                    self.presenter?.presentTranslations(translations)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.presentError(error)
                }
            }
        }
    }
    
    func fetchDefinitions(for word: String) {
        MistralWorker.shared.getDefinitions(for: word) { result in
            switch result {
            case .success(let definitions):
                DispatchQueue.main.async {
                    self.presenter?.presentDefinitions(definitions)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.presentError(error)
                }
            }
        }
    }
}
