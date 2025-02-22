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
        let router = MainRouter()

        viewController.router = router
        router.viewController = viewController

        return viewController
    }
}