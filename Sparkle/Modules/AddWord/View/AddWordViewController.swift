//
//  AddWordViewController.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

protocol AddWordDisplayLogic: AnyObject {
    func displayResult(_ viewModel: AddWordModels.ViewModel.SearchResult)
    func displayError(_ error: Error)
    func displayWordSaved()
}

final class AddWordViewController: UIViewController, UITextFieldDelegate {
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
        
        enum MainButton {
            static let width: CGFloat = 180
            static let height: CGFloat = 60
            static let font: UIFont = UIFont.systemFont(ofSize: 18, weight: .regular)
            static let cornerRadius: CGFloat = 15
            static let bgColor: UIColor = .systemGreen
        }
    }
    
    // MARK: - Properties
    var interactor: AddWordBusinessLogic?
    private var mainButtonAction: ButtonActions = .search
    
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
        searchView.textField.delegate = self
        card.setFrontView(to: searchView)
        card.setBackView(to: TranslationView())
        card.configure(with: WordModel(id: UUID(), word: "", partOfSpeech: "", transcription: "", translation: "", definition: ""))
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
        mainButton.titleLabel?.font = Constants.MainButton.font
        mainButton.backgroundColor = Constants.MainButton.bgColor
        mainButton.layer.cornerRadius = Constants.MainButton.cornerRadius
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        view.addSubview(mainButton)
        mainButton.setWidth(Constants.MainButton.width)
        mainButton.setHeight(Constants.MainButton.height)
        mainButton.pinBottom(to: cancelButton.topAnchor, 10)
        mainButton.pinCenterX(to: view)
    }
    
    private func configureStackView() {
        stackView.isHidden = true
        view.addSubview(stackView)
        stackView.setWidth(Constants.Card.size)
        stackView.setHeight(Constants.Card.size + 50)
        stackView.pinTop(to: card)
        stackView.pinCenterX(to: view)
    }
    
    // MARK: - Button Targets
    @objc private func mainButtonTapped() {
         switch mainButtonAction {
         case .search:
             if let frontView = card.frontView as? SearchView, let input = frontView.textField.text {
                 mainButton.isEnabled = false
                 let request = AddWordModels.Request.Search(word: input, mode: frontView.mode)
                 interactor?.fetchResult(for: request)
             }
         case .save:
             if let model = stackView.getTopWordModel() {
                 let request = AddWordModels.Request.Add(word: model)
                 interactor?.addWord(request)
                 cancelButtonTapped()
             }
         }
    }
    
    @objc private func cancelButtonTapped() {
         cancelButton.isHidden = true
         mainButton.setTitle("Найти", for: .normal)
         mainButton.isEnabled = false
         stackView.collapse { [self] in
             if let frontView = card.frontView as? SearchView {
                 frontView.textField.text = ""
             }
            
             if let topCardWordModel = stackView.getTopWordModel() {
                 card.backView?.configure(with: topCardWordModel)
             }
            
             card.isHidden = false
             stackView.isHidden = true
             card.flip {
                 self.mainButton.isEnabled = true
                 self.mainButtonAction = .search
             }
         }
    }
    
    // MARK: - UITextFieldDelegate Implementation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mainButtonTapped()
        return true
    }
}

extension AddWordViewController: AddWordDisplayLogic {
    func displayResult(_ viewModel: AddWordModels.Search.ViewModel) {
         cancelButton.isHidden = false
         errorLabel.isHidden = true
         card.setBackView(to: viewModel.mode == .translation ? TranslationView() : DefinitionView())
        if let first = viewModel.firstWordModel {
             card.backView?.configure(with: first)
         }

         card.flip { [self] in
             card.isHidden = true
             stackView.isHidden = false
             mainButton.isEnabled = true
             mainButton.setTitle(viewModel., for: .normal)
             mainButtonAction = .save
         }
    }
    
    func displayError(_ error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        mainButton.isEnabled = true
    }

    func displayWordSaved() {}

}

extension AddWordViewController: CardStackViewDelegate {
    func cardStack(_ cardStack: CardStackView, didSwipeCardIndex index: Int, in direction: CardStackView.SwipeDirection) {
        <#code#>
    }
}

@available(iOS 17.0, *)
#Preview {
    AddWordBuilder.build()
}
