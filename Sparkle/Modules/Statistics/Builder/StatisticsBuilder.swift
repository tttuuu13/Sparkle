//
//  StatisticsBuilder.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import Foundation

final class StatisticsBuilder {
    static func build() -> StatisticsViewController {
        let viewController = StatisticsViewController()
        let interactor = StatisticsInteractor()
        let presenter = StatisticsPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
