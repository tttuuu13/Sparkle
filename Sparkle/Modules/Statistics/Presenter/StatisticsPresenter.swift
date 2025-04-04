//
//  StatisticsPresenter.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import UIKit

protocol StatisticsPresentationLogic {
    func presentStatistics(response: StatisticsModels.LoadStatistics.Response)
}

final class StatisticsPresenter: StatisticsPresentationLogic {
    // MARK: - Properties
    weak var viewController: StatisticsDisplayLogic?
    
    func presentStatistics(response: StatisticsModels.LoadStatistics.Response) {
        let streakTile = StatisticsModels.LoadStatistics.ViewModel.StreakTile(mainText: "Вы занимаетесь \(response.streakDays) дн. подряд!", bottomText: "\(response.maxStreakDays) - ваш рекорд.", currentDayOfWeek: response.currentDayOfWeek, activeDaysOfWeek: response.activeDaysOfWeek)
        let wordsTotalTile = GraphTileViewModel(number: Int(response.wordsTotal.last ?? 0), secondaryLabelText: getChangeString(from: response.wordsTotal), text: "всего слов", data: response.wordsTotal, backgroundColor: .systemBlue.withAlphaComponent(0.2), mainColor: .systemBlue)
        let wordsReviewedToday = GraphTileViewModel(number: Int(response.wordsLearned.last ?? 0), secondaryLabelText: getChangeString(from: response.wordsReviewed), text: "выучено", data: response.wordsReviewed, backgroundColor: .systemGreen.withAlphaComponent(0.2), mainColor: .systemGreen)
        let wordsLearned = GraphTileViewModel(number: Int(response.wordsReviewed.last ?? 0), secondaryLabelText: getChangeString(from: response.wordsLearned), text: "повторено", data: response.wordsLearned, backgroundColor: .systemPurple.withAlphaComponent(0.2), mainColor: .systemPurple)
        let wordsWaitingForReview = GraphTileViewModel(number: Int(response.wordsToReview.last ?? 0), secondaryLabelText: getChangeString(from: response.wordsToReview), text: "повторить", data: response.wordsToReview, backgroundColor: .systemOrange.withAlphaComponent(0.2), mainColor: .systemOrange)
        let viewModel = StatisticsModels.LoadStatistics.ViewModel(streakTile: streakTile, wordsTotalTile: wordsTotalTile, wordsReviewedToday: wordsReviewedToday, wordsLearned: wordsLearned, wordsWaitingForReview: wordsWaitingForReview)
        viewController?.displayStatistics(viewModel: viewModel)
    }
    
    // MARK: - Private Methods
    private func getChangeString(from data: [Double]) -> String? {
        if data.count < 2 { return nil }
        guard let last = data.last else { return nil }
        let delta = last - data[data.count - 2]
        var result = String(format: "%.0f", delta)
        if delta >= 0 {
            result = "+" + result
        }
        
        return result
    }
}

