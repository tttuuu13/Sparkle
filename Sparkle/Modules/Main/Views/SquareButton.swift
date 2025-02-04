//
//  SquareButton.swift
//  Sparkle
//
//  Created by тимур on 28.12.2024.
//

import UIKit

// MARK: - Custom Square Button with Image
final class SquareButton: UIButton {
    // MARK: - Initializers
    init(title: String, titleColor: UIColor, image: UIImage?, backgroundColor: UIColor) {
        super.init(frame: .zero)
        configureUI()
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layer.cornerRadius = 20
        clipsToBounds = true
        
        setWidth(Constants.Button.size)
        setHeight(Constants.Button.size)
        
        configureTitle()
        configureImageView()
    }
    
    private func configureTitle() {
        titleLabel?.numberOfLines = 0
        titleLabel?.font = Constants.Title.font
        
        titleLabel?.pinLeft(to: self, Constants.Title.offset)
        titleLabel?.pinRight(to: self, Constants.Title.offset)
        titleLabel?.pinTop(to: self, Constants.Title.offset)
    }
    
    private func configureImageView() {
        imageView?.setWidth(Constants.Icon.size)
        imageView?.setHeight(Constants.Icon.size)
        imageView?.pinRight(to: self, Constants.Icon.offset)
        imageView?.pinBottom(to: self, Constants.Icon.offset)
    }
    
    // MARK: - Constants
    private enum Constants {
        enum Button {
            static let size: CGFloat = 165
            static let opacity: CGFloat = 0.2
        }
        
        enum Icon {
            static let size: CGFloat = 130
            static let offset: CGFloat = -27
            static let opacity: CGFloat = 0.7
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 28, weight: .semibold)
            static let offset: CGFloat = 10
        }
    }
}

// MARK: - Preview
#Preview {
    let button = SquareButton(title: "повторить слова", titleColor: .systemBlue, image: UIImage(systemName: "globe"), backgroundColor: .systemBlue.withAlphaComponent(0.2))
    return button
}
