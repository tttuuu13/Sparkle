//
//  AddWordViewController.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

protocol AddWordPresenterOutput: AnyObject {
    func displayTranslations(_ translations: [TranslationModel])
    func displayError(_ message: String)
}

final class AddWordViewController: UIViewController {
    var interactor: AddWordInteractor?
    
    // MARK: - UI Elements
    private var card: CardView<SearchView, TranslationView> = CardView<SearchView, TranslationView>(isFlipped: false)
    private let searchButton: UIButton = UIButton(type: .system)
    private let cancelButton: UIButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.View.bgColor

        configureCard()
        configureCancelButton()
        configureSearchButton()
    }
    
    private func configureCard() {
        card = CardView<SearchView, TranslationView>(isFlipped: false)
        card.configure(with: (SearchModel(mode: .translation), TranslationModel(text: "еб")))
        view.addSubview(card)

        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 45
        
        card.setWidth(Constants.Card.size)
        card.setHeight(Constants.Card.size)
        card.pinCenter(to: view)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("cбросить", for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.isHidden = true
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 10)
        cancelButton.pinCenterX(to: view)
    }
    
    private func configureSearchButton() {
        searchButton.setTitle("Перевести", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = Constants.SearchButton.font
        searchButton.backgroundColor = Constants.SearchButton.bgColor
        searchButton.layer.cornerRadius = Constants.SearchButton.cornerRadius
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        view.addSubview(searchButton)
        searchButton.setWidth(Constants.SearchButton.width)
        searchButton.setHeight(Constants.SearchButton.height)
        searchButton.pinBottom(to: cancelButton.topAnchor, 10)
        searchButton.pinCenterX(to: view)
    }
    
    // MARK: - Animations
    
    
    // MARK: - Button Targets
    @objc private func searchButtonTapped() {
        if let input = card.frontView.textField.text {
            self.interactor?.fetchTranslations(for: input)
        }
    }
    
    @objc private func cancelButtonTapped() {
        cancelButton.isHidden = true
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let bgColor: UIColor = UIColor(white: 0.95, alpha: 1)
        }
        
        enum Card {
            static let size: CGFloat = 320
        }
        
        enum TextField {
            static let font: UIFont = UIFont.systemFont(ofSize: 32, weight: .semibold)
            static let textColor: UIColor = .black.withAlphaComponent(0.9)
        }
        
        enum SearchButton {
            static let width: CGFloat = 180
            static let height: CGFloat = 60
            static let font: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let cornerRadius: CGFloat = 15
            static let bgColor: UIColor = .systemGreen
        }
    }
}

extension AddWordViewController: AddWordPresenterOutput {
    func displayTranslations(_ translations: [TranslationModel]) {
        cancelButton.isHidden = false
        card.backView.configure(with: <#T##TranslationView.Model#>)
        card.flip {}
    }
    
    func displayError(_ message: String) {}
}

#Preview {
    AddWordModuleBuilder.build()
}
