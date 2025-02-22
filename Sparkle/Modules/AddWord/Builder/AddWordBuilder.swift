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

        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        interactor.mistralWorker = mistralWorker
        
        return viewController
    }
}
