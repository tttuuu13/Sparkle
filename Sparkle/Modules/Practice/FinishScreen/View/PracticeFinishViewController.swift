//
//  PracticeFinishViewController.swift
//  Sparkle
//
//  Created by тимур on 17.04.2025.
//

import UIKit
import SwiftUI

class PracticeFinishViewController: UIViewController {
    private var swiftUIView: PracticeFinishView!

    init(wordsPracticed: Int, wordsTotal: Int, buttonAction: @escaping () -> Void = {}) {
        swiftUIView = PracticeFinishView(wordsPracticed: wordsPracticed, wordsTotal: wordsTotal, buttonAction: buttonAction)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.pinHorizontal(to: view)
        hostingController.view.pinVertical(to: view)
        hostingController.didMove(toParent: self)
    }
}
