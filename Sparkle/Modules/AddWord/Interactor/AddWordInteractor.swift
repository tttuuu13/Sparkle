//
//  AddWordLogic.swift
//  Sparkle
//
//  Created by тимур on 23.01.2025.
//
import Foundation

// MARK: - Interactor Protocol
protocol AddWordBusinessLogic {
    func loadInitialState(_ request: AddWordModels.Initial.Request)
    func searchWord(_ request: AddWordModels.Search.Request)
    func saveWord(_ request: AddWordModels.SaveWord.Request)
    func handleTopCardSwipe(_ request: AddWordModels.TopCardSwipe.Request)
    func returnToInitialState(_ request: AddWordModels.ReturnToInitial.Request)
    func toggleDisplayMode(_ request: AddWordModels.ToggleDisplayMode.Request)
}

// MARK: - Interactor Implementation
final class AddWordInteractor: AddWordBusinessLogic {
    var presenter: AddWordPresentationLogic?
    var llmWorker: LLMWorkerProtocol?
    private var cardViewModels: [CardViewModel] = []
    private var wordsInitialCount: Int = 0
    private var displayMode: CardFaceType = .translation
    private let wordsStorage = WordsStorage.shared
    
    func loadInitialState(_ request: AddWordModels.Initial.Request) {
        let response = AddWordModels.Initial.Response(
            card: AddWordModels.Initial.Response.Card(
                viewModel: CardViewModel(wordModel: WordModel.empty, frontType: .search, backType: .translation)
            )
        )
        presenter?.presentInitialState(response)
    }

    func searchWord(_ request: AddWordModels.Search.Request) {
        presenter?.presentLoading(AddWordModels.Loading.Response(isLoading: true))
        llmWorker?.getWordModels(for: request.word, mode: displayMode) { result in
            switch result {
            case .success(let wordModels):
                self.cardViewModels = wordModels.map { CardViewModel(wordModel: $0, frontType: self.displayMode, backType: .word) }
                self.wordsInitialCount = wordModels.count
                let response = AddWordModels.Search.Response(
                    state: .found,
                    firstCardViewModel: CardViewModel(wordModel: wordModels.first ?? WordModel.empty, frontType: .search, backType: self.displayMode)
                )
                DispatchQueue.main.async {
                    self.presenter?.presentSearchResult(response)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.presentError(error)
                }
            }
        }
    }

    func saveWord(_ request: AddWordModels.SaveWord.Request) {
        do {
            var word = request.word
            word.addedDate = Date()
            try wordsStorage.addWord(word)
            let response = AddWordModels.ReturnToInitial.Response(
                topCardViewModel: cardViewModels.first ?? CardViewModel(wordModel: WordModel.empty, frontType: .search, backType: .translation)
            )
            presenter?.presentReturnToInitialState(response)
        } catch {
            presenter?.presentError(error)
        }
    }
    
    func handleTopCardSwipe(_ request: AddWordModels.TopCardSwipe.Request) {
        cardViewModels.append(cardViewModels.removeFirst())
    }
    
    func returnToInitialState(_ request: AddWordModels.ReturnToInitial.Request) {
        let response = AddWordModels.ReturnToInitial.Response(
            topCardViewModel: cardViewModels.first ?? CardViewModel(wordModel: WordModel.empty, frontType: .search, backType: .translation)
        )
        presenter?.presentReturnToInitialState(response)
    }
    
    func toggleDisplayMode(_ request: AddWordModels.ToggleDisplayMode.Request) {
        displayMode = displayMode == .translation ? .definition : .translation
        presenter?.presentToggleDisplayMode(AddWordModels.ToggleDisplayMode.Response(mode: displayMode))
    }
}

extension AddWordInteractor: CardStackViewDataSource {
    func numberOfCards(in cardStack: CardStackView) -> Int {
        cardViewModels.count
    }
    
    func cardStack(_ cardStack: CardStackView, cardViewModelAt index: Int) -> CardViewModel {
        cardViewModels[index]
    }
}
