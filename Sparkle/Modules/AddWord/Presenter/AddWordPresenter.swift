//
//  AddWordPresenter.swift
//  Sparkle
//
//  Created by тимур on 26.01.2025.
//
import UIKit

// MARK: - Presenter Protocol
protocol AddWordPresentationLogic {
    func presentInitialState(_ response: AddWordModels.Initial.Response)
    func presentSearchResult(_ response: AddWordModels.Search.Response)
    func presentLoading(_ response: AddWordModels.Loading.Response)
    func presentError(_ error: Error)
    func presenTopCardSwipe(_ response: AddWordModels.TopCardSwipe.Response)
    func presentReturnToInitialState(_ response: AddWordModels.ReturnToInitial.Response)
    func presentToggleDisplayMode(_ response: AddWordModels.ToggleDisplayMode.Response)
}

// MARK: - Presenter Implementation
final class AddWordPresenter: AddWordPresentationLogic {
    weak var viewController: AddWordDisplayLogic?
    
    func presentInitialState(_ response: AddWordModels.Initial.Response) {
        let viewModel = AddWordModels.Initial.ViewModel(
            card: AddWordModels.Initial.ViewModel.Card(
                viewModel: response.card.viewModel,
                shadowOpacity: AddWordConstants.Card.shadowOpacity,
                shadowRadius: AddWordConstants.Card.shadowRadius,
                size: AddWordConstants.Card.size
            ),
            view: AddWordModels.Initial.ViewModel.View(
                backgroundColor: AddWordConstants.View.backgroundColor
            ),
            errorLabel: AddWordModels.Initial.ViewModel.ErrorLabel(
                text: "",
                font: AddWordConstants.ErrorLabel.font,
                textColor: AddWordConstants.ErrorLabel.textColor,
                textAlignment: AddWordConstants.ErrorLabel.textAlignment,
                numberOfLines: AddWordConstants.ErrorLabel.numberOfLines,
                offset: AddWordConstants.ErrorLabel.offset
            ),
            cancelButton: AddWordModels.Initial.ViewModel.CancelButton(
                title: AddWordConstants.CancelButton.title,
                titleColor: AddWordConstants.CancelButton.titleColor,
                isHidden: AddWordConstants.CancelButton.isHidden,
                offset: AddWordConstants.CancelButton.offset
            ),
            mainButton: AddWordModels.Initial.ViewModel.MainButton(
                title: AddWordConstants.MainButton.findTitle,
                titleColor: AddWordConstants.MainButton.titleColor,
                tintColor: AddWordConstants.MainButton.tintColor,
                action: .search,
                font: AddWordConstants.MainButton.font,
                backgroundColor: AddWordConstants.MainButton.backgroundColor,
                cornerRadius: AddWordConstants.MainButton.cornerRadius,
                isEnabled: AddWordConstants.MainButton.isEnabled,
                size: AddWordConstants.MainButton.size,
                offset: AddWordConstants.MainButton.offset
            ),
            stackView: AddWordModels.Initial.ViewModel.StackView(
                isHidden: AddWordConstants.StackView.isHidden,
                size: AddWordConstants.StackView.size
            )
        )
        viewController?.displayInitialState(viewModel)
    }

    func presentLoading(_ response: AddWordModels.Loading.Response) {
        let viewModel = AddWordModels.Loading.ViewModel(
            isLoading: response.isLoading,
            mainButton: AddWordModels.Loading.ViewModel.MainButton(
                isEnabled: !response.isLoading,
                title: AddWordConstants.MainButton.loadingTitle
            )
        )
        viewController?.displayLoading(viewModel)
    }

    func presentSearchResult(_ response: AddWordModels.Search.Response) {
        let viewModel = AddWordModels.Search.ViewModel(
            firstCardViewModel: response.firstCardViewModel,
            mainButton: AddWordModels.Search.ViewModel.MainButton(
                title: AddWordConstants.MainButton.saveTitle,
                isEnabled: true,
                action: .save
            ),
            cancelButton: AddWordModels.Search.ViewModel.CancelButton(
                isHidden: false
            ),
            errorLabel: AddWordModels.Search.ViewModel.ErrorLabel(
                isHidden: false,
                text: ""
            ),
            card: AddWordModels.Search.ViewModel.Card(
                isHidden: false
            )
        )
        viewController?.displaySearchResult(viewModel)
    }

    func presentError(_ error: Error) {
        viewController?.displayError(error)
    }
    
    func presenTopCardSwipe(_ response: AddWordModels.TopCardSwipe.Response) {
        let viewModel = AddWordModels.TopCardSwipe.ViewModel()
        viewController?.displayTopCardSwipe(viewModel)
    }
    
    func presentReturnToInitialState(_ response: AddWordModels.ReturnToInitial.Response) {
        let wordModel = response.topCardViewModel.wordModel
        let newWordModel = WordModel(id: wordModel.id, word: "", partOfSpeech: wordModel.partOfSpeech, transcription: wordModel.transcription, translation: wordModel.translation, definition: wordModel.definition)
        let cardViewModel = CardViewModel(wordModel: newWordModel, frontType: .search, backType: .translation)
        let viewModel = AddWordModels.ReturnToInitial.ViewModel(
            card: AddWordModels.ReturnToInitial.ViewModel.Card(
                isHidden: false,
                viewModel: cardViewModel
            ),
            mainButton: AddWordModels.ReturnToInitial.ViewModel.MainButton(title: AddWordConstants.MainButton.findTitle, action: .search),
            cancelButton: AddWordModels.ReturnToInitial.ViewModel.CancelButton(isHidden: true)
        )
        viewController?.displayReturnToInitialState(viewModel)
    }
    
    func presentToggleDisplayMode(_ response: AddWordModels.ToggleDisplayMode.Response) {
        let viewModel = AddWordModels.ToggleDisplayMode.ViewModel(
            image: response.mode == .translation ? UIImage(systemName: "globe")! : UIImage(systemName: "book.circle")!
        )
        viewController?.displayToggleDisplayMode(viewModel)
    }
}
