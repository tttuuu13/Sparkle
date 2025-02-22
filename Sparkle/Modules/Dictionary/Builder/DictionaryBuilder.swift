//
//  DictionaryBuilder.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

final class DictionaryBuilder {
    static func build() -> UIViewController {
        let viewController = DictionaryViewController()
        let interactor = DictionaryInteractor()
        let presenter = DictionaryPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}
