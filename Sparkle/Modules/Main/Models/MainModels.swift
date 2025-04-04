//
//  MainModels.swift
//  Sparkle
//
//  Created by тимур on 23.03.2025.
//

import Foundation

enum MainModels {
    enum LoadInitialState {
        struct Request {}
        
        struct Response {
            let streak: Int
            let isTodayActive: Bool
            let wordsReviewed: Int
            let wordsToReviewTotal: Int
        }
        
        struct ViewModel {
            let streak: Int
            let isTodayActive: Bool
            let wordsReviewed: Int
            let wordsToReviewTotal: Int
            let progress: Float
        }
    }
}
