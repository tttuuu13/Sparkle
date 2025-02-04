//
//  MainViewController.swift
//  Sparkle
//
//  Created by тимур on 07.01.2025.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Fields
    private var buttonsStack = UIStackView()
    private let profileButton = UIButton()
    private let streakFlame = StreakFlame()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        view.layoutMargins = Constants.View.margins
        view.backgroundColor = Constants.View.bgColor
        configureProfileButton()
        configureStreakFlame()
        configureButtons()
    }
    
    // MARK: - Profile Button Configuration
    private func configureProfileButton() {
        profileButton.setImage(Constants.ProfileButton.image, for: .normal)
        profileButton.imageView?.setWidth(Constants.ProfileButton.imageSize)
        profileButton.imageView?.setHeight(Constants.ProfileButton.imageSize)
        profileButton.backgroundColor = Constants.ProfileButton.bgColor
        profileButton.layer.cornerRadius = Constants.ProfileButton.size / 2
        
        
        view.addSubview(profileButton)
        profileButton.setWidth(Constants.ProfileButton.size)
        profileButton.setHeight(Constants.ProfileButton.size)
        profileButton.pinTop(to: view.layoutMarginsGuide.topAnchor)
        profileButton.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }
    
    // MARK: - Streak Flame Configuration
    private func configureStreakFlame() {
        view.addSubview(streakFlame)
        streakFlame.pinTop(to: profileButton.bottomAnchor, 15)
        streakFlame.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }
    
    // MARK: - Button Configuration
    private func configureButtons() {
        let row1 = UIStackView()
        row1.distribution = .equalSpacing
        buttonsStack.addArrangedSubview(row1)
        
        let progressButton = SquareButton(
            title: Constants.ProgressButton.title,
            titleColor: Constants.ProgressButton.titleColor,
            image: Constants.ProgressButton.image,
            backgroundColor: Constants.ProgressButton.bgColor
        )
        row1.addArrangedSubview(progressButton)
        
        let addButton = SquareButton(
            title: Constants.AddButton.title,
            titleColor: Constants.AddButton.titleColor,
            image: Constants.AddButton.image,
            backgroundColor: Constants.AddButton.bgColor
        )
        row1.addArrangedSubview(addButton)
        
        let row2 = UIStackView()
        row2.distribution = .equalSpacing
        buttonsStack.addArrangedSubview(row2)
        
        let dictionaryButton = SquareButton(
            title: Constants.DictionaryButton.title,
            titleColor: Constants.DictionaryButton.titleColor,
            image: Constants.DictionaryButton.image,
            backgroundColor: Constants.DictionaryButton.bgColor
        )
        row2.addArrangedSubview(dictionaryButton)
        
        let practiceButton = SquareButton(
            title: Constants.PracticeButton.title,
            titleColor: Constants.PracticeButton.titleColor,
            image: Constants.PracticeButton.image,
            backgroundColor: Constants.PracticeButton.bgColor
        )
        row2.addArrangedSubview(practiceButton)
        
        
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .equalSpacing
        
        view.addSubview(buttonsStack)
        buttonsStack.heightAnchor.constraint(equalTo: buttonsStack.widthAnchor).isActive = true
        buttonsStack.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
        buttonsStack.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
        buttonsStack.pinTop(to: streakFlame.bottomAnchor, 100)
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let margins: UIEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            static let bgColor: UIColor = .white.withAlphaComponent(0.95)
        }
        
        enum ButtonStack {
            static let spacing: CGFloat = 15
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
            static let title = "добавить слово"
            static let titleColor: UIColor = UIColor(red: 0, green: 61 / 255, blue: 128 / 255, alpha: 0.7)
            static let image: UIImage? = UIImage(systemName: "globe")?.withTintColor(.systemBlue.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
        
        enum DictionaryButton {
            static let bgColor: UIColor = .systemPurple.withAlphaComponent(0.2)
            static let title = "cловарь"
            static let titleColor: UIColor = UIColor(red: 101 / 255, green: 47 / 255, blue: 129 / 255, alpha: 0.7)
            static let image: UIImage? = UIImage(systemName: "square.stack.3d.up.fill")?.withTintColor(.systemPurple.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
        
        enum PracticeButton {
            static let bgColor: UIColor = .systemGreen.withAlphaComponent(0.2)
            static let title = "повторить слова"
            static let titleColor: UIColor = UIColor(red: 34 / 255, green: 130 / 255, blue: 58 / 255, alpha: 0.7)
            static let image: UIImage? = UIImage(systemName: "repeat.circle")?.withTintColor(.systemGreen.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        }
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview {
    MainViewController()
}
