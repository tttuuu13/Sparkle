//
//  WordsManager.swift
//  Sparkle
//
//  Created by тимур on 12.03.2025.
//

import Foundation

protocol WordsManagerProtocol {
    func getWordsForReview() -> [WordModel]
    func updateWordStats(for wordModel: WordModel, swipeDirection: SwipeDirection)
}

final class WordsManager: WordsManagerProtocol {
    // MARK: - Properties
    private let wordsStorage = WordsStorage.shared

    func getWordsForReview() -> [WordModel] {
        guard let words = try? wordsStorage.getWords() else { return [] }
        return words.filter { $0.knowledgeLevel < 0.75 }
    }
    
    func updateWordStats(for wordModel: WordModel, swipeDirection: SwipeDirection) {
        var wordModel = wordModel
        
        switch swipeDirection {
        case .left:
            wordModel.leftSwipes += 1
            wordModel.rightSwipesInRow = 0
            wordModel.repetitionStage = 0
        case .right:
            wordModel.lastSuccessfullReviewDate = Date()
            wordModel.rightSwipes += 1
            wordModel.repetitionStage += 1
        }

        wordModel.lastReviewDate = Date()
        try? wordsStorage.updateWord(wordModel)
    }
    
    // MARK: - Private Methods
}
