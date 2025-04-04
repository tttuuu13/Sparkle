//
//  StatisticsInteractor.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import UIKit

protocol StatisticsBusinessLogic {
    func loadStatistics(_ request: StatisticsModels.LoadStatistics.Request)
}

final class StatisticsInteractor: StatisticsBusinessLogic {
    // MARK: - Properties
    var presenter: StatisticsPresentationLogic?
    private let statisticsManager = StatisticsManager()
    
    func loadStatistics(_ request: StatisticsModels.LoadStatistics.Request) {
        let response = StatisticsModels.LoadStatistics.Response(
            streakDays: 6,
            maxStreakDays: 30,
            wordsTotal: [41, 49, 54],
            wordsLearned: [7, 10, 13],
            wordsReviewed: [24, 15, 30],
            wordsToReview: [40, 15, 35],
            activeDaysOfWeek: [.monday, .tuesday, .wednesday, .thursday, .friday],
            currentDayOfWeek: .friday
        )
        presenter?.presentStatistics(response: response)
    }
}
