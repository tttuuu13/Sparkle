//
//  Builder.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
import UIKit

final class AddWordModuleBuilder {
    static func build() -> UIViewController {
        let viewController = AddWordViewController()
        let interactor = AddWordInteractor()
        let presenter = AddWordPresenter()
        let textToSpeechWorker = TextToSpeechWorker()
        
        viewController.interactor = interactor
        presenter.view = viewController
        interactor.presenter = presenter
        interactor.textToSpeechWorker = textToSpeechWorker
        
        return viewController
    }
}
