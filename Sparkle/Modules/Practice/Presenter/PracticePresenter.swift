//
//  PracticePresenter.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol PracticePresentationLogic {
    func presentCards(response: PracticeModel.LoadCards.Response)
    func presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response)
    func presentTopCardSwipe(response: PracticeModel.HandleTopCardSwipe.Response)
    func presentDeleteWord(response: PracticeModel.DeleteTopWord.Response)
    func presentError(_ error: Error)
}

final class PracticePresenter: PracticePresentationLogic {
    weak var viewController: PracticeDisplayLogic?

    func presentCards(response: PracticeModel.LoadCards.Response) {
        viewController?.displayCards(viewModel: PracticeModel.LoadCards.ViewModel(
            progress: response.progress
        ))
    }

    func presentTopCardSwipe(response: PracticeModel.HandleTopCardSwipe.Response) {
        viewController?.displayTopCardSwipe(viewModel: PracticeModel.HandleTopCardSwipe.ViewModel(
            progress: response.progress
        ))
    }
    
    func presentSmartShuffle(response: PracticeModel.LoadSmartShuffle.Response) {
        switch response.state {
        case .loading:
            viewController?.displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel(
                icon: UIImage(systemName: "clock")!,
                iconTintColor: .systemGray3,
                needsUpdate: false
            ))
        case .enabled:
            viewController?.displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel(
                icon: UIImage(systemName: "sparkles.rectangle.stack.fill")!,
                iconTintColor: .systemGreen,
                needsUpdate: true
            ))
        case .failure(_):
            viewController?.displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel(
                icon: UIImage(systemName: "exclamationmark.triangle.fill")!,
                iconTintColor: .systemGray3,
                needsUpdate: false
            ))
        case .disabled:
            viewController?.displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel(
                icon: UIImage(systemName: "sparkles.rectangle.stack.fill")!,
                iconTintColor: .systemGray3,
                needsUpdate: true
            ))
        }
    }
    
    func presentDeleteWord(response: PracticeModel.DeleteTopWord.Response) {
        viewController?.displayDeleteWord(viewModel: PracticeModel.DeleteTopWord.ViewModel(progress: response.progress))
    }

    func presentError(_ error: any Error) {
        
    }
}
