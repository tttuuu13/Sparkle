//
//  SearchView.swift
//  Sparkle
//
//  Created by тимур on 04.02.2025.
//

import UIKit

struct SearchViewModel: CardFaceViewModel {
    let word: String
    var mode: CardFaceType
}

final class SearchView: CardFaceView {
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
    var onModeSelectorButtonTap: (() -> Void)?
    private var viewModel: SearchViewModel?
    
    // MARK: - UI Elements
    let textField: UITextField = UITextField()
    let modeSelectorButton: UIButton = UIButton()
    
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
        guard let viewModel = viewModel as? SearchViewModel else { return }

        textField.text = viewModel.word
        self.viewModel = viewModel
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTextField()
        configureModeSelectorButton()
    }
    
    private func configureTextField() {
        textField.font = Constants.TextField.font
        textField.placeholder = Constants.TextField.placeholder
        textField.textAlignment = .center

        addSubview(textField)
        textField.pinHorizontal(to: self)
        textField.pinCenterY(to: self)
    }
    
    private func configureModeSelectorButton() {
        modeSelectorButton.setImage(Constants.ModeSelectorButton.translationIcon, for: .normal)
        modeSelectorButton.contentVerticalAlignment = .fill
        modeSelectorButton.contentHorizontalAlignment = .fill
        modeSelectorButton.addTarget(self, action: #selector(modeSelectorButtonTapped), for: .touchUpInside)
        
        addSubview(modeSelectorButton)
        modeSelectorButton.setWidth(Constants.ModeSelectorButton.size)
        modeSelectorButton.setHeight(Constants.ModeSelectorButton.size)
        modeSelectorButton.pinRight(to: layoutMarginsGuide.trailingAnchor)
        modeSelectorButton.pinBottom(to: layoutMarginsGuide.bottomAnchor)
    }
    
    // MARK: - Button Targets
    @objc private func modeSelectorButtonTapped() {
        onModeSelectorButtonTap?()
    }
}
