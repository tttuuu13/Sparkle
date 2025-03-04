//
//  PracticeRouter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol PracticeRoutingLogic {
    func routeToFinish()
}

class PracticeRouter: PracticeRoutingLogic {
    // MARK: - Properties
    weak var viewController: UIViewController?

    // MARK: - Routing
    func routeToFinish() {
    }
}