//
//  StatisticsViewController.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import UIKit

protocol StatisticsDisplayLogic: AnyObject {
    func displayStatistics(viewModel: StatisticsModels.LoadStatistics.ViewModel)
}

final class StatisticsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let backgroundColor: UIColor = .background
            static let insets: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    
    // MARK: - Properties
    var interactor: StatisticsBusinessLogic?
    
    // MARK: - UI Elements
    private let streakTile = StreakTile()
    private let stackView = UIStackView()
    private let wordsTotalTile = GraphTile()
    private let wordsReviewedToday = GraphTile()
    private let wordsLearned = GraphTile()
    private let wordsWaitingForReview = GraphTile()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor?.loadStatistics(.init())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.View.backgroundColor
        view.layoutMargins = Constants.View.insets
        navigationItem.title = "Прогресс"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureStreakTile()
        configureStackView()
    }
    
    private func configureStreakTile() {
        view.addSubview(streakTile)
        streakTile.pinTop(to: view.layoutMarginsGuide.topAnchor)
        streakTile.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
        streakTile.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }

    private func configureStackView() {
        let firstRow = UIStackView(arrangedSubviews: [wordsTotalTile, wordsReviewedToday])
        firstRow.axis = .horizontal
        firstRow.distribution = .fillEqually
        firstRow.spacing = 16
        stackView.addArrangedSubview(firstRow)
        
        let secondRow = UIStackView(arrangedSubviews: [wordsLearned, wordsWaitingForReview])
        secondRow.axis = .horizontal
        secondRow.distribution = .fillEqually
        secondRow.spacing = 16
        stackView.addArrangedSubview(secondRow)
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.pinTop(to: streakTile.bottomAnchor, 16)
        stackView.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
        stackView.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
        stackView.pinHeight(to: stackView.widthAnchor)
    }
}

extension StatisticsViewController: StatisticsDisplayLogic {
    func displayStatistics(viewModel: StatisticsModels.LoadStatistics.ViewModel) {
        streakTile.configure(activeDaysOfWeek: viewModel.streakTile.activeDaysOfWeek, today: viewModel.streakTile.currentDayOfWeek)
        streakTile.setMainText(viewModel.streakTile.mainText)
        streakTile.setBottomText(viewModel.streakTile.bottomText)
        wordsTotalTile.configure(with: viewModel.wordsTotalTile)
        wordsLearned.configure(with: viewModel.wordsLearned)
        wordsReviewedToday.configure(with: viewModel.wordsReviewedToday)
        wordsWaitingForReview.configure(with: viewModel.wordsWaitingForReview)
    }
}

@available(iOS 17.0, *)
#Preview {
    StatisticsBuilder.build()
}
