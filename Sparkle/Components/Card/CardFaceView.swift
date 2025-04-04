//
//  CardFaceView.swift
//  Sparkle
//
//  Created by тимур on 07.03.2025.
//

import UIKit

protocol CardFaceViewModel {
}

class CardFaceView: UIView {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            static let backgroundColor: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        }
    }

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: CardFaceViewModel) {
    }
    
    private func configureUI() {
        backgroundColor = Constants.View.backgroundColor
        layoutMargins = Constants.View.insets
    }
}
