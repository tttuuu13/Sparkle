//
//  MainInteractor.swift
//  Sparkle
//
//  Created by тимур on 23.03.2025.
//

import Foundation

protocol MainBusinessLogic {
    func loadInitialState(_ request: MainModels.LoadInitialState.Request)
}

final class MainInteractor: MainBusinessLogic {
    var presenter: MainPresentationLogic?
    private let statisticsManager = StatisticsManager()
    private let wordsManager = WordsManager()

    func loadInitialState(_ request: MainModels.LoadInitialState.Request) {
        print(statisticsManager.getWordsReviewedCount(days: 1))
        let wordsReviewed = statisticsManager.getWordsReviewedCount(days: 1).first ?? 0
        let wordsToReviewTotal = wordsManager.getWordsForReview().count + wordsReviewed
        let response = MainModels.LoadInitialState.Response(
            streak: statisticsManager.getStreak().0,
            isTodayActive: statisticsManager.getStreak().1,
            wordsReviewed: wordsReviewed,
            wordsToReviewTotal: wordsToReviewTotal
        )
        presenter?.presentInitiialState(response)
    }
}
