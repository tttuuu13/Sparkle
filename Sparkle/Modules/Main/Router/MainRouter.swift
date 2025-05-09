//
//  MainRouter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

protocol MainRoutingLogic {
    func routeToAddWord()
    func routeToDictionary()
    func routeToPractice()
    func routeToProgress()
    func routeToSettings()
    func routeToProfile()
}

final class MainRouter: MainRoutingLogic {
    weak var viewController: MainViewController?

    func routeToAddWord() {
        let addWordVC = AddWordBuilder.build()
        viewController?.navigationController?.pushViewController(addWordVC, animated: true)
    }

    func routeToDictionary() {
        let dictionaryVC = DictionaryBuilder.build()
        viewController?.navigationController?.pushViewController(dictionaryVC, animated: true)
    }

    func routeToPractice() {
        let practiceVC = PracticeBuilder.build()
        viewController?.navigationController?.pushViewController(practiceVC, animated: true)
    }

    func routeToProgress() {
        let progressVC = StatisticsBuilder.build()
        viewController?.navigationController?.pushViewController(progressVC, animated: true)
    }

    func routeToSettings() {
        
    }

    func routeToProfile() {
        
    }
}
