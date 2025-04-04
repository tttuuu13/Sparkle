//
//  WordView.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

struct WordViewModel: CardFaceViewModel {
    let word: String
}

final class WordView: CardFaceView {
    // MARK: - Constants
    private enum Constants {
        enum TextField {
            static let font: UIFont = UIFont.systemFont(ofSize: 30, weight: .medium)
            static let placeholder: String = "слово"
        }
        
        enum ModeSelectorButton {
            static let translationIcon: UIImage = UIImage(systemName: "globe")!
            static let definitionIcon: UIImage = UIImage(systemName: "book.circle")!
            static let size: CGFloat = 50
        }
    }
    
    // MARK: - Properties
    private var viewModel: WordViewModel?
    
    // MARK: - UI Elements
    let textLabel: UILabel = UILabel()
    
    // MARK: - Initializers
    override init() {
        super.init()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    override func configure(with viewModel: CardFaceViewModel) {
        guard let viewModel = viewModel as? WordViewModel else { return }

        textLabel.text = viewModel.word
        
        self.viewModel = viewModel
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTextLabel()
    }
    
    private func configureTextLabel() {
        textLabel.font = Constants.TextField.font
        textLabel.textAlignment = .center

        addSubview(textLabel)
        textLabel.pinHorizontal(to: self)
        textLabel.pinCenterY(to: self)
    }
}

