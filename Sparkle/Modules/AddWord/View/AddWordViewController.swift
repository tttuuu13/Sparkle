//
//  AddWordViewController.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

protocol AddWordDisplayLogic: AnyObject {
    func displayInitialState(_ viewModel: AddWordModels.Initial.ViewModel)
    func displayLoading(_ viewModel: AddWordModels.Loading.ViewModel)
    func displaySearchResult(_ viewModel: AddWordModels.Search.ViewModel)
    func displayError(_ error: Error)
    func displayTopCardSwipe(_ viewModel: AddWordModels.TopCardSwipe.ViewModel)
    func displayReturnToInitialState(_ viewModel: AddWordModels.ReturnToInitial.ViewModel)
    func displayToggleDisplayMode(_ viewModel: AddWordModels.ToggleDisplayMode.ViewModel)
}

final class AddWordViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    var interactor: (AddWordBusinessLogic & CardStackViewDataSource)?
    private var mainButtonAction: ButtonActions = .search
    
    // MARK: - UI Elements
    private var card: Card = Card()
    private let stackView: CardStackView = CardStackView(swipeMode: .cycle, areCardsFlipped: true, areCardsFlippable: false)
    private let mainButton: UIButton = UIButton(type: .system)
    private let cancelButton: UIButton = UIButton(type: .system)
    private let errorLabel: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func loadInitialState() {
        let request = AddWordModels.Initial.Request()
        interactor?.loadInitialState(request)
    }
    
    // MARK: - UI Configuration
    private func configureCard(with viewModel: AddWordModels.Initial.ViewModel.Card) {
        let searchView = SearchView()
        searchView.textField.delegate = self
        searchView.onModeSelectorButtonTap = modeSelectorButtonTapped
        card.setFrontView(to: searchView)
        card.setBackView(to: viewModel.viewModel.createBackView())
        view.addSubview(card)

        card.layer.shadowOpacity = viewModel.shadowOpacity
        card.layer.shadowRadius = viewModel.shadowRadius
        
        card.setWidth(viewModel.size.width)
        card.setHeight(viewModel.size.height)
        card.pinCenter(to: view)
    }
    
    private func configureErrorLabel(with viewModel: AddWordModels.Initial.ViewModel.ErrorLabel) {
        errorLabel.font = viewModel.font
        errorLabel.textColor = viewModel.textColor
        errorLabel.textAlignment = viewModel.textAlignment
        errorLabel.numberOfLines = viewModel.numberOfLines
        errorLabel.isHidden = true
        
        view.addSubview(errorLabel)
        errorLabel.pinCenterX(to: view)
        errorLabel.pinTop(to: card.bottomAnchor, viewModel.offset)
        errorLabel.pinWidth(to: card)
    }
    
    private func configureCancelButton(with viewModel: AddWordModels.Initial.ViewModel.CancelButton) {
        cancelButton.setTitle(viewModel.title, for: .normal)
        cancelButton.setTitleColor(viewModel.titleColor, for: .normal)
        cancelButton.isHidden = viewModel.isHidden
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, viewModel.offset)
        cancelButton.pinCenterX(to: view)
    }
    
    private func configureMainButton(with viewModel: AddWordModels.Initial.ViewModel.MainButton) {
        mainButton.setTitle(viewModel.title, for: .normal)
        mainButton.setTitleColor(viewModel.titleColor, for: .normal)
        mainButton.tintColor = viewModel.tintColor
        mainButton.titleLabel?.font = viewModel.font
        mainButton.backgroundColor = viewModel.backgroundColor
        mainButton.layer.cornerRadius = viewModel.cornerRadius
        mainButtonAction = viewModel.action
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        
        view.addSubview(mainButton)
        mainButton.setWidth(viewModel.size.width)
        mainButton.setHeight(viewModel.size.height)
        mainButton.pinBottom(to: cancelButton.topAnchor, viewModel.offset)
        mainButton.pinCenterX(to: view)
    }
    
    private func configureStackView(with viewModel: AddWordModels.Initial.ViewModel.StackView) {
        stackView.delegate = self
        stackView.dataSource = interactor
        stackView.isHidden = viewModel.isHidden
        view.insertSubview(stackView, at: 0)
        stackView.setWidth(viewModel.size.width)
        stackView.setHeight(viewModel.size.height)
        stackView.pinTop(to: card)
        stackView.pinCenterX(to: view)
    }
    
    // MARK: - Button Targets
    @objc private func mainButtonTapped() {
         switch mainButtonAction {
         case .search:
             if let frontView = card.frontView as? SearchView, let input = frontView.textField.text {
                 mainButton.isEnabled = false
                 let request = AddWordModels.Search.Request(word: input)
                 interactor?.searchWord(request)
             }
         case .save:
             if let viewModel = stackView.getTopCardViewModel() {
                 let request = AddWordModels.SaveWord.Request(word: viewModel.wordModel)
                 interactor?.saveWord(request)
             }
         }
    }
    
    @objc private func cancelButtonTapped() {
        let request = AddWordModels.ReturnToInitial.Request()
        interactor?.returnToInitialState(request)
    }
    
    private func modeSelectorButtonTapped() {
        let request = AddWordModels.ToggleDisplayMode.Request()
        interactor?.toggleDisplayMode(request)
    }
    
    // MARK: - UITextFieldDelegate Implementation
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        mainButtonTapped()
        return true
    }
}

extension AddWordViewController: AddWordDisplayLogic {
    func displayInitialState(_ viewModel: AddWordModels.Initial.ViewModel) {
        view.backgroundColor = viewModel.view.backgroundColor
        configureCard(with: viewModel.card)
        configureErrorLabel(with: viewModel.errorLabel)
        configureCancelButton(with: viewModel.cancelButton)
        configureMainButton(with: viewModel.mainButton)
        configureStackView(with: viewModel.stackView)
    }

    func displayLoading(_ viewModel: AddWordModels.Loading.ViewModel) {
        mainButton.isEnabled = viewModel.mainButton.isEnabled
        mainButton.setTitle(viewModel.mainButton.title, for: .normal)
    }
    
    func displaySearchResult(_ viewModel: AddWordModels.Search.ViewModel) {
        cancelButton.isHidden = viewModel.cancelButton.isHidden
        errorLabel.isHidden = viewModel.errorLabel.isHidden
        if let firstCardViewModel = viewModel.firstCardViewModel {
            card.setBackView(to: firstCardViewModel.createBackView())
            card.backView?.configure(with: firstCardViewModel.createBackViewModel())
        }

        card.flip { [self] in
            stackView.reloadData()
            card.isHidden = true
            stackView.isHidden = false
            
            mainButtonAction = viewModel.mainButton.action
            mainButton.isEnabled = true
            mainButton.setTitle(viewModel.mainButton.title, for: .normal)
        }
    }
    
    func displayError(_ error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        mainButton.isEnabled = true
    }

    func displayTopCardSwipe(_ viewModel: AddWordModels.TopCardSwipe.ViewModel) {
        
    }
    
    func displayReturnToInitialState(_ viewModel: AddWordModels.ReturnToInitial.ViewModel) {
        stackView.collapse { [self] in
            card.configure(with: viewModel.card.viewModel)
            card.isHidden = false
            stackView.isHidden = true
            card.flip()
            mainButtonAction = viewModel.mainButton.action
            mainButton.setTitle(viewModel.mainButton.title, for: .normal)
            cancelButton.isHidden = viewModel.cancelButton.isHidden
        }
    }
    
    func displayToggleDisplayMode(_ viewModel: AddWordModels.ToggleDisplayMode.ViewModel) {
        if let searchView = card.frontView as? SearchView {
            searchView.modeSelectorButton.setImage(viewModel.image, for: .normal)
        }
    }
}

extension AddWordViewController: CardStackViewDelegate {
    func cardStack(_ cardStack: CardStackView, didSwipeCardIndex index: Int, in direction: SwipeDirection) {
        interactor?.handleTopCardSwipe(AddWordModels.TopCardSwipe.Request())
    }
}

@available(iOS 17.0, *)
#Preview {
    AddWordBuilder.build()
}
