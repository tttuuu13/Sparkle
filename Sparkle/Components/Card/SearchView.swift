//
//  SearchView.swift
//  Sparkle
//
//  Created by тимур on 04.02.2025.
//

import Foundation
import UIKit

enum SearchMode {
    case translation
    case definition
}
struct SearchModel: CardFaceModel {
    var mode: SearchMode
}

final class SearchView: UIView, ConfigurableView {    
    // MARK: - Fields
    var mode: SearchMode = .translation
    
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
    func configure(with model: CardFaceModel) {
        guard let model = model as? SearchModel else {
            print("View \(self) configured with wrong model type.")
            return
        }
        
        mode = model.mode
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        backgroundColor = .white
        layoutMargins = Constants.View.insets
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
        modeSelectorButton.setImage(mode == .translation ? Constants.ModeSelectorButton.translationIcon : Constants.ModeSelectorButton.definitionIcon, for: .normal)
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
        switch mode {
        case .translation:
            mode = .definition
        case .definition:
            mode = .translation
        }
        
        modeSelectorButton.setImage(mode == .translation ? Constants.ModeSelectorButton.translationIcon : Constants.ModeSelectorButton.definitionIcon, for: .normal)
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        enum TextField {
            static let font: UIFont = UIFont.systemFont(ofSize: 30, weight: .medium)
            static let placeholder: String = "слово"
        }
        
        enum ModeSelectorButton {
            static let translationIcon: UIImage = UIImage(systemName: "globe.americas.fill")!
            static let definitionIcon: UIImage = UIImage(systemName: "book.circle")!
            static let size: CGFloat = 50
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let view = SearchView()
    view.configure(with: SearchModel(mode: .translation))
    view.setWidth(320)
    view.setHeight(320)
    return view
}
