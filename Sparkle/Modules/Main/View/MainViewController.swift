//
//  MainViewController.swift
//  Sparkle
//
//  Created by тимур on 07.01.2025.
//

import UIKit

protocol MainDisplayLogic: AnyObject {
    func displayInitialState(_ viewModel: MainModels.LoadInitialState.ViewModel)
}

final class MainViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let margins: UIEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            static let bgColor: UIColor = .background
        }
        
        enum ButtonStack {
            static let spacing: CGFloat = 15
            static let offset: CGFloat = 30
        }
        
        enum ProfileButton {
            static let size: CGFloat = 60
            static let bgColor: UIColor = .systemBlue.withAlphaComponent(0.7)
            static let image: UIImage? = UIImage(systemName: "person.fill")?.withTintColor(.white.withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
            static let imageSize: CGFloat = 30
        }
        
        enum ProgressButton {
            static let bgColor: UIColor = .systemYellow.withAlphaComponent(0.2)
            static let title = "прогресс"
            static let titleColor: UIColor = UIColor(red: 135 / 255, green: 105 / 255, blue: 0, alpha: 0.7)
            static let image: UIImage? = UIImage(systemName: "sparkle")?.withTintColor(.systemYellow.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
        
        enum AddButton {
            static let bgColor: UIColor = .systemBlue.withAlphaComponent(0.2)
            static let title = "слово"
            static let titleFont: UIFont = .systemFont(ofSize: 30, weight: .semibold)
            static let titleColor: UIColor = UIColor(red: 0, green: 61 / 255, blue: 128 / 255, alpha: 0.7)
            static let image: UIImage = UIImage(systemName: "plus.circle.fill")!.withTintColor(.systemBlue.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
        
        enum DictionaryButton {
            static let bgColor: UIColor = .systemPurple.withAlphaComponent(0.2)
            static let title = "cловарь"
            static let titleColor: UIColor = UIColor(red: 101 / 255, green: 47 / 255, blue: 129 / 255, alpha: 0.7)
            static let image: UIImage? = UIImage(systemName: "square.stack.3d.up.fill")?.withTintColor(.systemPurple.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
        
        enum PracticeButton {
            static let bgColor: UIColor = .systemGreen.withAlphaComponent(0.2)
            static let title = "повторить\nслова"
            static let titleColor: UIColor = UIColor(red: 34 / 255, green: 130 / 255, blue: 58 / 255, alpha: 0.8)
            static let image: UIImage? = UIImage(systemName: "repeat.circle")?.withTintColor(.systemGreen.withAlphaComponent(0.8), renderingMode: .alwaysOriginal)
        }
        
        enum Counter {
            static let textColor: UIColor = .systemYellow
            static let font: UIFont = .rounded(ofSize: 34, weight: .black)
            static let shadowColor: CGColor = UIColor.systemYellow.cgColor
            static let sshahadowOpacity: Float = 1
            static let shadowRadius: CGFloat = 5
        }

        enum TitleLabel {
            static let font: UIFont = .systemFont(ofSize: 48, weight: .medium)
        }
    }
    
    // MARK: - Properties
    var interactor: MainBusinessLogic?
    var router: MainRoutingLogic?

    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private var buttonsStack = UIStackView()
    private let profileButton = UIButton()
    private let streakFlame = StreakFlame()
    private let counter: UILabel = UILabel()
    private let addWordButton = UIView()
    private let practiceProgressBar: UIProgressView = UIProgressView()
    let practiceProgressLabel: UILabel = UILabel()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.loadInitialState(.init())
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.layoutMargins = Constants.View.margins
        view.backgroundColor = Constants.View.bgColor
        configureTitle()
        configureProfileButton()
        configureStreakFlame()
        configureButtons()
        configureCounter()
    }

    private func configureTitle() {
        titleLabel.text = "sparkle"
        titleLabel.font = Constants.TitleLabel.font
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.layoutMarginsGuide.topAnchor)
        titleLabel.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
    }

    private func configureProfileButton() {
        profileButton.setImage(Constants.ProfileButton.image, for: .normal)
        profileButton.backgroundColor = Constants.ProfileButton.bgColor
        profileButton.layer.cornerRadius = Constants.ProfileButton.size / 2
        profileButton.imageView?.contentMode = .scaleAspectFit
        
        view.addSubview(profileButton)
        profileButton.setWidth(Constants.ProfileButton.size)
        profileButton.setHeight(Constants.ProfileButton.size)
        profileButton.pinTop(to: view.layoutMarginsGuide.topAnchor)
        profileButton.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }
    
    private func configureStreakFlame() {
        view.addSubview(streakFlame)
        streakFlame.setWidth(Constants.ProfileButton.size)
        streakFlame.setHeight(Constants.ProfileButton.size / StreakFlame.aspectRatio)
        streakFlame.pinTop(to: profileButton.bottomAnchor, 15)
        streakFlame.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }
    
    private func configureCounter() {
        counter.textColor = Constants.Counter.textColor
        counter.font = Constants.Counter.font
        counter.layer.shadowColor = Constants.Counter.shadowColor
        counter.layer.shadowOpacity = Constants.Counter.sshahadowOpacity
        counter.layer.shadowRadius = Constants.Counter.shadowRadius
        view.addSubview(counter)
        counter.pinCenterX(to: streakFlame)
        counter.pinCenterY(to: streakFlame, 5)
    }
    
    private func configureAddWordButton() {
        let iconView = UIImageView(image: Constants.AddButton.image)
        addWordButton.addSubview(iconView)
        iconView.setHeight(40)
        iconView.setWidth(40)
        iconView.pinCenterY(to: addWordButton)
        iconView.pinRight(to: addWordButton.trailingAnchor, 5)

        let textLabel = UILabel()
        textLabel.text = "слово"
        textLabel.font = Constants.AddButton.titleFont
        textLabel.textColor = Constants.AddButton.titleColor
        addWordButton.addSubview(textLabel)
        textLabel.pinCenterY(to: addWordButton, -2)
        textLabel.pinLeft(to: addWordButton.leadingAnchor, 20)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addWordButtonTapped))
        addWordButton.addGestureRecognizer(tapGesture)
        addWordButton.isUserInteractionEnabled = true
        addWordButton.backgroundColor = Constants.AddButton.bgColor
        addWordButton.layer.cornerRadius = 25


        view.addSubview(addWordButton)
        addWordButton.setHeight(50)
        addWordButton.setWidth(160)
        addWordButton.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
        addWordButton.pinBottom(to: view.layoutMarginsGuide.bottomAnchor, 40)
    }
    
    private func configureButtons() {
        configureAddWordButton()
        
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = Constants.ButtonStack.spacing
        
        view.addSubview(buttonsStack)
        buttonsStack.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
        buttonsStack.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
        buttonsStack.pinBottom(to: addWordButton.topAnchor, Constants.ButtonStack.offset)
        

        let statsButton = MenuButton(title: Constants.ProgressButton.title, titleColor: Constants.ProgressButton.titleColor, image: Constants.ProgressButton.image, backgroundColor: Constants.ProgressButton.bgColor)
        statsButton.pinHeight(to: statsButton.widthAnchor)
        statsButton.addAction(UIAction(handler: { _ in
            self.router?.routeToProgress()
        }), for: .touchUpInside)
        
        let dictButton = MenuButton(title: Constants.DictionaryButton.title, titleColor: Constants.DictionaryButton.titleColor, image: Constants.DictionaryButton.image, backgroundColor: Constants.DictionaryButton.bgColor)
        dictButton.pinHeight(to: dictButton.widthAnchor)
        dictButton.addAction(UIAction(
            handler: { _ in
            self.router?.routeToDictionary()
        }), for: .touchUpInside)
        
        let firstRow = UIStackView(arrangedSubviews: [statsButton, dictButton])
        firstRow.spacing = Constants.ButtonStack.spacing
        firstRow.distribution = .fillEqually
        buttonsStack.addArrangedSubview(firstRow)
        
        configurePracticeButton()
    }
    
    private func configurePracticeButton() {
        let practiceButton = MenuButton(title: Constants.PracticeButton.title, titleColor: Constants.PracticeButton.titleColor, image: Constants.PracticeButton.image, backgroundColor: Constants.PracticeButton.bgColor)
        practiceButton.addAction(UIAction(handler: { _ in
            self.router?.routeToPractice()
        }), for: .touchUpInside)
        
        practiceProgressBar.progress = 0
        practiceProgressBar.tintColor = Constants.PracticeButton.titleColor
        practiceProgressBar.backgroundColor = .systemGreen.withAlphaComponent(0.8)
        practiceProgressBar.clipsToBounds = true
        practiceProgressBar.layer.cornerRadius = 5
        
        practiceButton.addSubview(practiceProgressBar)
        practiceProgressBar.setHeight(10)
        practiceProgressBar.pinLeft(to: practiceButton.leadingAnchor, 20)
        practiceProgressBar.pinRight(to: practiceButton.trailingAnchor, 120)
        practiceProgressBar.pinBottom(to: practiceButton.bottomAnchor, 20)
        
        practiceProgressLabel.textColor = Constants.PracticeButton.titleColor
        practiceProgressLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        practiceButton.addSubview(practiceProgressLabel)
        practiceProgressLabel.pinLeft(to: practiceButton.leadingAnchor, 20)
        practiceProgressLabel.pinBottom(to: practiceProgressBar.topAnchor, 10)
        
        
        buttonsStack.addArrangedSubview(practiceButton)
    }

    @objc private func addWordButtonTapped() {
        router?.routeToAddWord()
    }
}

extension MainViewController: MainDisplayLogic {
    func displayInitialState(_ viewModel: MainModels.LoadInitialState.ViewModel) {
        counter.text = "\(viewModel.streak)"
        practiceProgressBar.setProgress(viewModel.progress, animated: true)

        practiceProgressLabel.text = "\(viewModel.wordsReviewed) из \(viewModel.wordsToReviewTotal) слов повторено"
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview {
    MainBuilder.build()
}
