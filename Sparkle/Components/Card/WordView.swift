//
//  WordView.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

final class WordView: UIView, ConfigurableView {
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
    private var model: WordModel?
    
    // MARK: - UI Elements
    let textLabel: UILabel = UILabel()
    
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
        textLabel.text = model.word
        
        self.model = model
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layoutMargins = Constants.View.insets
        backgroundColor = Constants.View.backgroundColor
        
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

