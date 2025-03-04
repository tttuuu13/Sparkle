//
//  SearchView.swift
//  Sparkle
//
//  Created by тимур on 04.02.2025.
//

import UIKit

enum DisplayMode {
    case translation
    case definition
}

final class SearchView: UIView, ConfigurableView {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            static let backgroundColor: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
        }
        
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
    var mode: DisplayMode = .translation {
        didSet {
            let image = mode == .translation ? Constants.ModeSelectorButton.translationIcon : Constants.ModeSelectorButton.definitionIcon
            modeSelectorButton.setImage(image, for: .normal)
        }
    }

    private var model: WordModel?
    
    // MARK: - UI Elements
    let textField: UITextField = UITextField()
    let modeSelectorButton: UIButton = UIButton()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with model: WordModel) {
        self.model = model
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layoutMargins = Constants.View.insets
        backgroundColor = Constants.View.backgroundColor
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
        mode = mode == .translation ? .definition : .translation
    }
}
