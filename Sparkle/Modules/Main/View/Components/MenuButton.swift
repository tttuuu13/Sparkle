//
//  SquareButton.swift
//  Sparkle
//
//  Created by тимур on 28.12.2024.
//

import UIKit

// MARK: - Custom Square Button with Image
final class MenuButton: UIButton {
    // MARK: - Constants
    private enum Constants {
        enum Button {
            static let opacity: CGFloat = 0.2
        }
        
        enum Icon {
            static let opacity: CGFloat = 0.7
        }
        
        enum Title {
            static let font: UIFont = .systemFont(ofSize: 28, weight: .semibold)
        }
    }
    
    // MARK: - Initializers
    init(title: String, titleColor: UIColor, image: UIImage?, backgroundColor: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setImage(image, for: .normal)
        self.backgroundColor = backgroundColor
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let buttonWidth = bounds.width
        let buttonHeight = bounds.height
        let imgSize = min(buttonWidth, buttonHeight) * 0.9
        
        imageView.frame = CGRect(x: buttonWidth - buttonHeight * 0.7, y: buttonHeight * 0.3, width: imgSize, height: imgSize)
        
        let titleLabelSize = titleLabel.sizeThatFits(CGSize(width: buttonWidth * 0.9, height: .greatestFiniteMagnitude))
        titleLabel.frame = CGRect(x: buttonWidth * 0.05, y: buttonWidth * 0.05, width: buttonWidth, height: titleLabelSize.height)
        titleLabel.font = Constants.Title.font
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
    }
}

@available(iOS 17.0, *)
#Preview {
    let button = MenuButton(title: "повторить слова", titleColor: .systemBlue, image: UIImage(systemName: "globe"), backgroundColor: .systemBlue.withAlphaComponent(0.2))
    button.setWidth(336)
    button.setHeight(160)
    return button
}
