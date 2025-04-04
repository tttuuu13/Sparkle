//
//  PracticeRouter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol PracticeRoutingLogic {
    func presentFinishScreenModal(wordsPracticed: Int, wordsTotal: Int)
}

class PracticeRouter: PracticeRoutingLogic {
    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Routing
    func presentFinishScreenModal(wordsPracticed: Int, wordsTotal: Int) {
        let vc = PracticeFinishViewController(wordsPracticed: wordsPracticed, wordsTotal: wordsTotal, buttonAction: dismissAndRouteBackToMenu)
        viewController?.present(vc, animated: true)
    }

    private func dismissAndRouteBackToMenu() {
        viewController?.dismiss(animated: true, completion: { [weak self] in
            self?.viewController?.navigationController?.popToRootViewController(animated: true)
        })
    }
}
