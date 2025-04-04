//
//  StatisticsModels.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import UIKit

enum StatisticsModels {
    enum LoadStatistics {
        struct Request {}

        struct Response {
            let streakDays: Int
            let maxStreakDays: Int
            let wordsTotal: [Double]
            let wordsLearned: [Double]
            let wordsReviewed: [Double]
            let wordsToReview: [Double]
            let activeDaysOfWeek: [WeekDay]
            let currentDayOfWeek: WeekDay
        }
        
        struct ViewModel {
            struct StreakTile {
                let mainText: String
                let bottomText: String
                let currentDayOfWeek: WeekDay
                let activeDaysOfWeek: [WeekDay]
            }
            
            let streakTile: StreakTile
            let wordsTotalTile: GraphTileViewModel
            let wordsReviewedToday: GraphTileViewModel
            let wordsLearned: GraphTileViewModel
            let wordsWaitingForReview: GraphTileViewModel
        }
    }
}
