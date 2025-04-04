//
//  MainPresenter.swift
//  Sparkle
//
//  Created by тимур on 23.03.2025.
//

import Foundation

protocol MainPresentationLogic {
    func presentInitiialState(_ response: MainModels.LoadInitialState.Response)
}

final class MainPresenter: MainPresentationLogic {
   weak  var viewController: MainDisplayLogic?
    
    func presentInitiialState(_ response: MainModels.LoadInitialState.Response) {
        let viewModel = MainModels.LoadInitialState.ViewModel(
            streak: response.streak,
            isTodayActive: response.isTodayActive,
            wordsReviewed: response.wordsReviewed,
            wordsToReviewTotal: response.wordsToReviewTotal,
            progress: Float(response.wordsReviewed) / Float(response.wordsToReviewTotal))
        viewController?.displayInitialState(viewModel)
    }
}
