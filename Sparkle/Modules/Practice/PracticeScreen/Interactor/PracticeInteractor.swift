//
//  PracticeInteractor.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol PracticeBusinessLogic {
    func loadCards(request: PracticeModel.LoadCards.Request)
    func toggleSmartShuffle()
    func handleTopCardSwipe(request: PracticeModel.HandleTopCardSwipe.Request)
    func deleteTopWord(request: PracticeModel.DeleteTopWord.Request)
    func finishPractice(request: PracticeModel.FinishPractice.Request)
}

final class PracticeInteractor: PracticeBusinessLogic {
    var presenter: PracticePresentationLogic?
    var wordsManager: WordsManagerProtocol?
    var LLMWorker: LLMWorkerProtocol?
    private let wordsStorage: WordsStorageProtocol = WordsStorage.shared
    var smartShuffle: Bool = false
    private var cardViewModels: [CardViewModel] = []
    private var cardsInitialCount: Int = 0

    func loadCards(request: PracticeModel.LoadCards.Request) {
        guard let wordsManager = wordsManager else { return }
        
        let words = wordsManager.getWordsForReview()
        cardViewModels = words.map { CardViewModel(wordModel: $0, frontType: .word, backType: .translation) }
        cardsInitialCount = words.count
        presenter?.presentCards(response: PracticeModel.LoadCards.Response(
            progress: Float(cardsInitialCount - cardViewModels.count) / Float(cardsInitialCount)
        ))
    }
    
    func toggleSmartShuffle() {
        guard let LLMWorker = LLMWorker else { return }
        
        smartShuffle.toggle()
        switch smartShuffle {
        case true:
            if !cardViewModels.isEmpty {
                presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                    state: .loading
                ))
                LLMWorker.getSmartShuffleWords(for: cardViewModels.map { $0.wordModel }, amount: cardViewModels.count / 4) { result in
                    switch result {
                    case .success(let words):
                        words.forEach { self.cardViewModels.insert(CardViewModel(
                            wordModel: $0,
                            frontType: .word,
                            backType: .translation,
                            isSmartShuffle: true),
                            at: self.cardViewModels.count > 1 ? Int.random(in: 1..<self.cardViewModels.count) : 1) }
                        self.cardsInitialCount += words.count
                        DispatchQueue.main.async {
                            self.presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                                state: .enabled
                            ))
                        }
                    case .failure(let error):
                        self.smartShuffle.toggle()
                        DispatchQueue.main.async {
                            self.presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                                state: .failure(error: error)
                            ))
                        }
                    }
                }
            }
        case false:
            cardsInitialCount -= cardViewModels.count(where: { $0.isSmartShuffle })
            cardViewModels.removeAll(where: { $0.isSmartShuffle })
            self.presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                state: .disabled
            ))
        }
    }

    func handleTopCardSwipe(request: PracticeModel.HandleTopCardSwipe.Request) {
        guard !cardViewModels.isEmpty else { return }

        let swipedCard = cardViewModels.removeFirst()

        switch request.direction {
        case .left:
            if swipedCard.isSmartShuffle {
                try? wordsStorage.addWord(swipedCard.wordModel)
            }
            
            cardViewModels.append(swipedCard)
        case .right:
            break
        }

        wordsManager?.updateWordStats(for: swipedCard.wordModel, swipeDirection: request.direction)
        if cardViewModels.isEmpty {
            presenter?.presentFinishScreen(response: PracticeModel.FinishPractice.Response(wordsPracticed: cardsInitialCount, wordsTotal: cardsInitialCount))
        } else {
            presenter?.presentTopCardSwipe(response: PracticeModel.HandleTopCardSwipe.Response(
                progress: Float(cardsInitialCount - cardViewModels.count) / Float(cardsInitialCount)
            ))
        }
    }
    
    func deleteTopWord(request: PracticeModel.DeleteTopWord.Request) {
        guard let topCard = cardViewModels.first else { return }
        try? wordsStorage.deleteWord(topCard.wordModel)
        cardViewModels.removeFirst()
        cardsInitialCount -= 1
        
        presenter?.presentDeleteWord(response: PracticeModel.DeleteTopWord.Response(
            progress: Float(cardsInitialCount - cardViewModels.count) / Float(cardsInitialCount)
        ))
    }

    func finishPractice(request: PracticeModel.FinishPractice.Request) {
        let response = PracticeModel.FinishPractice.Response(wordsPracticed: cardsInitialCount - cardViewModels.count, wordsTotal: cardsInitialCount)
        presenter?.presentFinishScreen(response: response)
    }
}


extension PracticeInteractor: CardStackViewDataSource {
    func cardStack(_ cardStack: CardStackView, cardViewModelAt index: Int) -> CardViewModel {
        return cardViewModels[index]
    }

    func numberOfCards(in cardStack: CardStackView) -> Int {
        return cardViewModels.count
    }
}
