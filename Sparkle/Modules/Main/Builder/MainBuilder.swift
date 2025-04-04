//
//  MainBuilder.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

final class MainBuilder {
    static func build() -> UIViewController {
        let viewController = MainViewController()
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
