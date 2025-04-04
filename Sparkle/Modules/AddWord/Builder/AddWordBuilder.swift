//
//  Builder.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
import UIKit

final class AddWordBuilder {
    static func build() -> UIViewController {
        let viewController = AddWordViewController()
        let interactor = AddWordInteractor()
        let presenter = AddWordPresenter()
        let mistralWorker = MistralWorker()
        let mockLLMWorker = LLMMockWorker()

        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.llmWorker = mistralWorker
        
        return viewController
    }
}
