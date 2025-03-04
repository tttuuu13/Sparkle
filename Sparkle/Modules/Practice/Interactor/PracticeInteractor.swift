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
}

final class PracticeInteractor: PracticeBusinessLogic {
    var presenter: PracticePresentationLogic?
    var smartShuffle: Bool = false
    private let wordsStorage = WordsStorage.shared
    private let mistralWorker = MistralWorker.shared
    private var wordModels: [WordModel] = []
    private var wordsInitialCount: Int = 0

    func loadCards(request: PracticeModel.LoadCards.Request) {
        do {
            //let words = try wordsStorage.getWords()
            let words = [
                WordModel(
                    id: UUID(),
                    word: "serendipity",
                    partOfSpeech: "noun",
                    transcription: "/ˌserənˈdɪpɪti/",
                    translation: "случайная удача",
                    definition: "the occurrence and development of events by chance in a happy or beneficial way"
                ),
                WordModel(
                    id: UUID(),
                    word: "ephemeral",
                    partOfSpeech: "adjective",
                    transcription: "/ɪˈfem(ə)rəl/",
                    translation: "недолговечный",
                    definition: "lasting for a very short time"
                ),
                WordModel(
                    id: UUID(),
                    word: "ubiquitous",
                    partOfSpeech: "adjective",
                    transcription: "/juːˈbɪkwɪtəs/",
                    translation: "вездесущий",
                    definition: "present, appearing, or found everywhere"
                ),
                WordModel(
                    id: UUID(),
                    word: "mellifluous",
                    partOfSpeech: "adjective",
                    transcription: "/məˈlɪfluəs/",
                    translation: "медоточивый",
                    definition: "sweet or musical; pleasant to hear"
                ),
                WordModel(
                    id: UUID(),
                    word: "paradigm",
                    partOfSpeech: "noun",
                    transcription: "/ˈparədʌɪm/",
                    translation: "парадигма",
                    definition: "a typical example or pattern of something"
                ),
                WordModel(
                    id: UUID(),
                    word: "eloquent",
                    partOfSpeech: "adjective",
                    transcription: "/ˈeləkwənt/",
                    translation: "красноречивый",
                    definition: "fluent or persuasive in speaking or writing"
                ),
                WordModel(
                    id: UUID(),
                    word: "resilient",
                    partOfSpeech: "adjective",
                    transcription: "/rɪˈzɪliənt/",
                    translation: "стойкий",
                    definition: "able to withstand or recover quickly from difficult conditions"
                ),
                WordModel(
                    id: UUID(),
                    word: "ethereal",
                    partOfSpeech: "adjective",
                    transcription: "/ɪˈθɪəriəl/",
                    translation: "эфирный",
                    definition: "extremely delicate and light in a way that seems not to be of this world"
                ),
                WordModel(
                    id: UUID(),
                    word: "panacea",
                    partOfSpeech: "noun",
                    transcription: "/ˌpanəˈsiːə/",
                    translation: "панацея",
                    definition: "a solution or remedy for all difficulties or diseases"
                ),
                WordModel(
                    id: UUID(),
                    word: "quintessential",
                    partOfSpeech: "adjective",
                    transcription: "/ˌkwɪntɪˈsenʃ(ə)l/",
                    translation: "типичный",
                    definition: "representing the most perfect or typical example of a quality or class"
                )
            ]
            wordModels = words
            wordsInitialCount = words.count
            presenter?.presentCards(response: PracticeModel.LoadCards.Response(
                progress: Float(wordsInitialCount - wordModels.count) / Float(wordsInitialCount)
            ))
        } catch {
            presenter?.presentError(error)
    
        }
    }
    
    func toggleSmartShuffle() {
        smartShuffle.toggle()
        switch smartShuffle {
        case true:
            if !wordModels.isEmpty {
                presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                    state: .loading
                ))
                mistralWorker.getSmartShuffleWords(for: wordModels, amount: wordModels.count / 4) { result in
                    switch result {
                    case .success(let words):
                        words.forEach { self.wordModels.insert($0, at: self.wordModels.count > 1 ? Int.random(in: 1..<self.wordModels.count) : 1) }
                        self.wordsInitialCount += words.count
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
            wordsInitialCount -= wordModels.count(where: { $0.isSmartShuffle })
            wordModels.removeAll(where: { $0.isSmartShuffle })
            self.presenter?.presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response(
                state: .disabled
            ))
        }
    }

    func handleTopCardSwipe(request: PracticeModel.HandleTopCardSwipe.Request) {
        guard !wordModels.isEmpty else { return }

        let swipedWord = wordModels.removeFirst()

        switch request.direction {
        case .left:
            wordModels.append(swipedWord)
        case .right:
            break
        }

        presenter?.presentTopCardSwipe(response: PracticeModel.HandleTopCardSwipe.Response(
            progress: Float(wordsInitialCount - wordModels.count) / Float(wordsInitialCount)
        ))
    }
    
    func deleteTopWord(request: PracticeModel.DeleteTopWord.Request) {
        guard let topWord = wordModels.first else { return }
        try? wordsStorage.deleteWord(topWord)
        wordModels.removeFirst()
        wordsInitialCount -= 1
        
        presenter?.presentDeleteWord(response: PracticeModel.DeleteTopWord.Response(
            progress: Float(wordsInitialCount - wordModels.count) / Float(wordsInitialCount)
        ))
    }
}

extension PracticeInteractor: CardStackViewDataSource {
    func cardStack(_ cardStack: CardStackView, wordModelAt index: Int) -> WordModel {
        return wordModels[index]
    }

    func numberOfCards(in cardStack: CardStackView) -> Int {
        return wordModels.count
    }
}
