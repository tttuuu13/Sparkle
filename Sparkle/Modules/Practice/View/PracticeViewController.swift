//
//  PracticeViewController.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol PracticeDisplayLogic: AnyObject {
    func displayCards(viewModel: PracticeModel.LoadCards.ViewModel)
    func displayTopCardSwipe(viewModel: PracticeModel.HandleTopCardSwipe.ViewModel)
    func displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel)
    func displayDeleteWord(viewModel: PracticeModel.DeleteTopWord.ViewModel)
}

class PracticeViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let backgroundColor: UIColor = UIColor(red: 238 / 255, green: 238 / 255, blue: 238 / 255, alpha: 1)
        }
        
        enum CardStack {
            static let size: CGSize = CGSize(width: 320, height: 350)
        }
        
        enum BottomView {
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
            static let height: CGFloat = 150
            static let backgroundColor: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
            static let cornerRadius: CGFloat = 25
            static let shadowOpacity: Float = 0.05
            static let shadowRadius: CGFloat = 40
            
        }
        
        enum ProgressBar {
            static let height: CGFloat = 8
            static let progressTintColor: UIColor = .systemGreen
        }

        enum FinishButton {
            static let size: CGSize = CGSize(width: 140, height: 50)
            static let text: String = "Завершить"
            static let backgroundColor: UIColor = .systemGreen
            static let cornerRadius: CGFloat = 12
            static let offset: CGFloat = 25
        }
        
        enum DeleteButton {
            static let size: CGSize = CGSize(width: 50, height: 50)
            static let backgroundColor: UIColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
            static let icon: UIImage = UIImage(systemName: "trash.fill")!
            static let tintColor: UIColor = UIColor(red: 212 / 255, green: 21 / 255, blue: 10 / 255, alpha: 0.67)
            static let shadowOpacity: Float = 0.1
            static let shadowRadius: CGFloat = 20
        }
        
        enum SmartShuffleButton {
            static let size: CGSize = CGSize(width: 50, height: 50)
            static let icon: UIImage = UIImage(systemName: "sparkles.rectangle.stack.fill")!
            static let activeTintColor: UIColor = .systemGreen
            static let inactiveTintColor: UIColor = .systemGray3
        }
        
        enum StreakFlame {
            static let offset: CGPoint = CGPoint(x: 20, y: 20)
        }
    }
    
    // MARK: - Properties
    var interactor: (PracticeBusinessLogic & CardStackViewDataSource)?
    
    // MARK: - UI Elements
    private var cardStack: CardStackView = CardStackView(mode: .definition, swipeMode: .remove)
    private let bottomView: UIView = UIView()
    private let finishButton: UIButton = UIButton(type: .system)
    private let deleteButton: UIButton = UIButton(type: .system)
    private let progressBar: UIProgressView = UIProgressView()
    private let smartShuffleButton: UIButton = UIButton(type: .system)
    private let streakFlame: StreakFlame = StreakFlame()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        interactor?.loadCards(request: PracticeModel.LoadCards.Request())
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.View.backgroundColor
        
        configureCardStack()
        configureStreakFlame()
        configureBottomView()
    }
    
    private func configureCardStack() {
        cardStack.delegate = self
        cardStack.dataSource = interactor

        view.addSubview(cardStack)
        cardStack.pinCenter(to: view)
        cardStack.setWidth(Constants.CardStack.size.width)
        cardStack.setHeight(Constants.CardStack.size.height)
    }
    
    func configureStreakFlame() {
        view.insertSubview(streakFlame, at: 0)
        streakFlame.pinRight(to: view.trailingAnchor, Constants.StreakFlame.offset.x)
        streakFlame.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.StreakFlame.offset.y)
    }
    
    private func configureBottomView() {
        bottomView.layoutMargins = Constants.BottomView.insets
        bottomView.backgroundColor = Constants.BottomView.backgroundColor
        bottomView.layer.cornerRadius = Constants.BottomView.cornerRadius
        bottomView.layer.shadowOpacity = Constants.BottomView.shadowOpacity
        bottomView.layer.shadowRadius = Constants.BottomView.shadowRadius
        
        view.addSubview(bottomView)
        bottomView.pinHorizontal(to: view)
        bottomView.pinBottom(to: view)
        bottomView.setHeight(Constants.BottomView.height)
        
        configureProgressBar()
        configureFinishButton()
        configureDeleteButton()
        configureSmartShuffleButton()
    }
    
    private func configureProgressBar() {
        progressBar.clipsToBounds = true
        progressBar.layer.cornerRadius = Constants.ProgressBar.height / 2
        progressBar.progressTintColor = Constants.ProgressBar.progressTintColor
        
        bottomView.addSubview(progressBar)
        progressBar.pinLeft(to: bottomView.layoutMarginsGuide.leadingAnchor)
        progressBar.pinRight(to: bottomView.layoutMarginsGuide.trailingAnchor)
        progressBar.pinTop(to: bottomView.layoutMarginsGuide.topAnchor)
        progressBar.setHeight(Constants.ProgressBar.height)
    }
    
    private func configureFinishButton() {
        finishButton.layer.cornerRadius = Constants.FinishButton.cornerRadius
        finishButton.backgroundColor = Constants.FinishButton.backgroundColor
        finishButton.setTitle(Constants.FinishButton.text, for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)

        bottomView.addSubview(finishButton)
        finishButton.setWidth(Constants.FinishButton.size.width)
        finishButton.setHeight(Constants.FinishButton.size.height)
        finishButton.pinTop(to: progressBar.bottomAnchor, Constants.FinishButton.offset)
        finishButton.pinCenterX(to: bottomView)
    }
    
    private func configureDeleteButton() {
        deleteButton.layer.cornerRadius = Constants.DeleteButton.size.height / 2
        deleteButton.backgroundColor = Constants.DeleteButton.backgroundColor
        deleteButton.layer.shadowOpacity = Constants.DeleteButton.shadowOpacity
        deleteButton.layer.shadowRadius = Constants.DeleteButton.shadowRadius
        deleteButton.setImage(Constants.DeleteButton.icon, for: .normal)
        deleteButton.tintColor = Constants.DeleteButton.tintColor
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        bottomView.addSubview(deleteButton)
        deleteButton.setWidth(Constants.DeleteButton.size.width)
        deleteButton.setHeight(Constants.DeleteButton.size.height)
        deleteButton.pinRight(to: bottomView.layoutMarginsGuide.trailingAnchor)
        deleteButton.pinCenterY(to: finishButton)
        
    }
    
    private func configureSmartShuffleButton() {
        smartShuffleButton.setImage(Constants.SmartShuffleButton.icon, for: .normal)
        smartShuffleButton.tintColor = Constants.SmartShuffleButton.inactiveTintColor
        smartShuffleButton.addTarget(self, action: #selector(smartShuffleButtonTapped), for: .touchUpInside)
        
        bottomView.addSubview(smartShuffleButton)
        smartShuffleButton.setWidth(Constants.SmartShuffleButton.size.width)
        smartShuffleButton.setHeight(Constants.SmartShuffleButton.size.height)
        smartShuffleButton.pinCenterY(to: finishButton)
        smartShuffleButton.pinLeft(to: bottomView.layoutMarginsGuide.leadingAnchor)
    }

    // MARK: - Button Targets
    @objc private func finishButtonTapped() {
        print("finishButtonTapped")
    }

    @objc private func deleteButtonTapped() {
        interactor?.deleteTopWord(request: PracticeModel.DeleteTopWord.Request())
    }

    @objc private func smartShuffleButtonTapped() {
        interactor?.toggleSmartShuffle()
    }
}

extension PracticeViewController: PracticeDisplayLogic {
    func displayCards(viewModel: PracticeModel.LoadCards.ViewModel) {
        progressBar.progress = viewModel.progress
        cardStack.reloadData()
    }
    
    func displaySmartShuffle(viewModel: PracticeModel.LoadSmartShuffle.ViewModel) {
        smartShuffleButton.setImage(viewModel.icon, for: .normal)
        smartShuffleButton.tintColor = viewModel.iconTintColor

        if viewModel.needsUpdate {
            cardStack.reloadData()
        }
    }

    func displayTopCardSwipe(viewModel: PracticeModel.HandleTopCardSwipe.ViewModel) {
        progressBar.setProgress(viewModel.progress, animated: true)
        cardStack.reloadData()
    }
    
    func displayDeleteWord(viewModel: PracticeModel.DeleteTopWord.ViewModel) {
        progressBar.setProgress(viewModel.progress, animated: true)
        cardStack.reloadData()
    }
}

extension PracticeViewController: CardStackViewDelegate {
    func cardStack(_ cardStack: CardStackView, didSwipeCardIndex index: Int, in direction: CardStackView.SwipeDirection) {
        streakFlame.counter = direction == .right ? streakFlame.counter + 1 : 0
        
        interactor?.handleTopCardSwipe(request: PracticeModel.HandleTopCardSwipe.Request(direction: direction))
    }
}

@available(iOS 17.0, *)
#Preview {
    PracticeBuilder.build()
}
