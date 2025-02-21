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
        streakFlame.pinTop(to: profileButton.bottomAnchor, 15)
        streakFlame.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
    }
    
    private func configureButtons() {
        buttonsStack.axis = .vertical
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = Constants.ButtonStack.spacing
        
        view.addSubview(buttonsStack)
        buttonsStack.pinLeft(to: view.layoutMarginsGuide.leadingAnchor)
        buttonsStack.pinRight(to: view.layoutMarginsGuide.trailingAnchor)
        buttonsStack.pinBottom(to: view.layoutMarginsGuide.bottomAnchor, Constants.ButtonStack.offset)
        
        let rows = [UIStackView(), UIStackView()]
        
        let buttonConfigs = [
            (Constants.ProgressButton.title, Constants.ProgressButton.titleColor, Constants.ProgressButton.image, Constants.ProgressButton.bgColor),
            (Constants.AddButton.title, Constants.AddButton.titleColor, Constants.AddButton.image, Constants.AddButton.bgColor),
            (Constants.DictionaryButton.title, Constants.DictionaryButton.titleColor, Constants.DictionaryButton.image, Constants.DictionaryButton.bgColor),
            (Constants.PracticeButton.title, Constants.PracticeButton.titleColor, Constants.PracticeButton.image, Constants.PracticeButton.bgColor)
        ]
        
        for (row, buttonConfig) in zip(rows, buttonConfigs.chuncked(into: 2)) {
            row.distribution = .fillEqually
            row.spacing = Constants.ButtonStack.spacing
            buttonsStack.addArrangedSubview(row)
            
            for config in buttonConfig {
                let button = SquareButton(title: config.0, titleColor: config.1, image: config.2, backgroundColor: config.3)
                row.addArrangedSubview(button)
            }
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let margins: UIEdgeInsets = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
            static let bgColor: UIColor = .white.withAlphaComponent(0.95)
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
