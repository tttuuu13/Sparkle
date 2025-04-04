//
//  PracticeBuilder.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

final class PracticeBuilder {
    static func build() -> PracticeViewController {
        let viewController = PracticeViewController()
        let interactor = PracticeInteractor()
        let presenter = PracticePresenter()
        let router = PracticeRouter()
        let llmWorker = MistralWorker()
        let wordsManager = WordsManager()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.LLMWorker = llmWorker
        interactor.wordsManager = wordsManager
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
