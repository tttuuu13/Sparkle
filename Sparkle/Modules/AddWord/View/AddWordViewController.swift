//
//  AddWordViewController.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

protocol AddWordDisplayLogic: AnyObject {
    func displayResult(_ wordModels: [WordModel], mode: SearchMode)
    func displayError(_ error: Error)
    func displayWordSaved()
}

final class AddWordViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    var interactor: AddWordBusinessLogic?
    private var buttonState: ButtonActions = .search
    
    // MARK: - UI Elements
    private var card: CardView = CardView()
    private let stackView: CardStackView = CardStackView()
    private let mainButton: UIButton = UIButton(type: .system)
    private let cancelButton: UIButton = UIButton(type: .system)
    private let errorLabel: UILabel = UILabel()
    
    // MARK: - Enums
    private enum ButtonActions {
        case search
        case save
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.View.bgColor

        configureCard()
        configureErrorLabel()
        configureCancelButton()
        configureMainButton()
        configureStackView()
    }
    
    private func configureCard() {
        let searchView = SearchView()
        searchView.configure(with: SearchModel(mode: .translation))
        searchView.textField.delegate = self
        card.setFrontView(to: searchView)
        card.setBackView(to: TranslationView())
        card.configure(with: (SearchModel(mode: .translation), nil))
        view.addSubview(card)

        card.layer.shadowOpacity = 0.1
        card.layer.shadowRadius = 45
        
        card.setWidth(Constants.Card.size)
        card.setHeight(Constants.Card.size)
        card.pinCenter(to: view)
    }
    
    private func configureErrorLabel() {
        errorLabel.font = Constants.ErrorLabel.font
        errorLabel.textColor = Constants.ErrorLabel.textColor
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        view.addSubview(errorLabel)
        errorLabel.pinCenterX(to: view)
        errorLabel.pinTop(to: card.bottomAnchor, 10)
        errorLabel.pinWidth(to: card)
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
    
    private func configureMainButton() {
        mainButton.setTitle("Найти", for: .normal)
        mainButton.setTitleColor(.white, for: .normal)
        mainButton.tintColor = .white
        mainButton.titleLabel?.font = Constants.SearchButton.font
        mainButton.backgroundColor = Constants.SearchButton.bgColor
        mainButton.layer.cornerRadius = Constants.SearchButton.cornerRadius
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        view.addSubview(mainButton)
        mainButton.setWidth(Constants.SearchButton.width)
        mainButton.setHeight(Constants.SearchButton.height)
        mainButton.pinBottom(to: cancelButton.topAnchor, 10)
        mainButton.pinCenterX(to: view)
    }
    
    private func configureStackView() {
        stackView.isHidden = true
        view.addSubview(stackView)
        stackView.setWidth(Constants.Card.size)
        stackView.setHeight(Constants.Card.size * 1.5)
        stackView.pinTop(to: card)
        stackView.pinCenterX(to: view)
    }
    
    // MARK: - Button Targets
    @objc private func mainButtonTapped() {
        switch buttonState {
        case .search:
            if let frontView = card.frontView as? SearchView, let input = frontView.textField.text {
                mainButton.isEnabled = false
                interactor?.fetchResult(for: input, mode: frontView.mode)
            }
        case .save:
            if let model = stackView.getTopCardModel().0 as? WordModel {
                interactor?.addWord(model)
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        cancelButton.isHidden = true
        mainButton.setTitle("Найти", for: .normal)
        mainButton.setImage(nil, for: .normal)
        mainButton.isEnabled = false
        stackView.collapse { [self] in
            card.backView?.configure(with: stackView.getTopCardModel().0)
            card.isHidden = false
            stackView.isHidden = true
            card.flip {
                self.mainButton.isEnabled = true
            }
        }
    }
    
    // MARK: - UITextFieldDelegate Implementation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mainButtonTapped()
        return true
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let bgColor: UIColor = UIColor(white: 0.95, alpha: 1)
        }
        
        enum Card {
            static let size: CGFloat = 320
        }
        
        enum ErrorLabel {
            static let font: UIFont = UIFont.systemFont(ofSize: 18, weight: .medium)
            static let textColor: UIColor = UIColor(red: 1, green: 149 / 255, blue: 0, alpha: 1)
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

extension AddWordViewController: AddWordDisplayLogic {
    func displayResult(_ wordModels: [WordModel], mode: SearchMode) {
        cancelButton.isHidden = false
        errorLabel.isHidden = true
        card.setBackView(to: mode == .translation ? TranslationView() : DefinitionView())
        if let first = wordModels.first {
            card.backView?.configure(with: first)
        }

        card.flip { [self] in
            card.isHidden = true
            stackView.isHidden = false
            stackView.configure(with: wordModels.map { ($0, nil) }, mode: mode)
            mainButton.setTitle("Запомнить", for: .normal)
            mainButton.setImage(UIImage(systemName: "sparkle"), for: .normal)
            mainButton.isEnabled = true
            stackView.expand()
        }
    }
    
    func displayError(_ error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        mainButton.isEnabled = true
    }

    func displayWordSaved() {}

}

@available(iOS 17.0, *)
#Preview {
    AddWordBuilder.build()
}
