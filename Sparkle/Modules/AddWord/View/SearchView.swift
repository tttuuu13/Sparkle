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
struct SearchModel {
    var mode: SearchMode
}

final class SearchView: UIView, ConfigurableView {
    // MARK: - Typealias for conformance
    typealias Model = SearchModel
    
    // MARK: - Fields
    private var mode: SearchMode = .translation
    
    // MARK: - UI Elements
    let textField: UITextField = UITextField()
    let modeSelectorButton: UIButton = UIButton()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        ConfigureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with model: Model) {
        mode = model.mode
    }
    
    // MARK: - UI Configuration
    private func ConfigureUI() {
        backgroundColor = .white
        configureTextField()
    }
    
    private func configureTextField() {
        textField.font = Constants.TextField.font
        textField.placeholder = Constants.TextField.placeholder
        addSubview(textField)
        textField.pinCenter(to: self)
    }
    
    // MARK: - Constants
    private enum Constants {
        enum TextField {
            static let font: UIFont = UIFont.systemFont(ofSize: 30, weight: .medium)
            static let placeholder: String = "слово"
        }
    }
}

#Preview {
    let view = SearchView()
    view.configure(with: SearchModel(mode: .translation))
    view.setWidth(320)
    view.setHeight(320)
    return view
}
