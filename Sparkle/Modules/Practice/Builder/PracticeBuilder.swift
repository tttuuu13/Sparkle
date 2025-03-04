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

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }
}