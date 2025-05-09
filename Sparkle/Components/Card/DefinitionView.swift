//
//  DefinitionView.swift
//  Sparkle
//
//  Created by тимур on 10.02.2025.
//

import AVFoundation
import UIKit

struct DefinitionViewModel: CardFaceViewModel {
    let word: String
    let wordClass: String
    let definition: String
    let example: String? = nil
}

final class DefinitionView: CardFaceView {
    // MARK: - Constants
    private enum Constants {
        enum WordClassLabel {
            static let font: UIFont = .systemFont(ofSize: 14, weight: .regular)
            static let textColor: UIColor = .white
            static let backgroundColor: UIColor = .systemBlue
            static let size: CGSize = CGSize(width: 82, height: 26)
        }
        
        enum DefinitionLabel {
            static let font: UIFont = .systemFont(ofSize: 18, weight: .regular)
            static let textColor: UIColor = .white
            static let offset: CGFloat = 10
        }
        
        enum ExampleView {
            static let backgroundColor: UIColor = .systemBlue.withAlphaComponent(0.1)
            static let iconColor: UIColor = UIColor.systemBlue
            static let borderWidth: CGFloat = 1
            static let size: CGSize = CGSize(width: 50, height: 50)
            static let offset: CGFloat = 10
            static let cornerRadius: CGFloat = 14
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            enum Text {
                static let font: UIFont = .systemFont(ofSize: 18, weight: .regular)
                static let color: UIColor = .systemBlue
            }
        }
        
        enum SoundButton {
            static let size: CGFloat = 50
        }
        
        enum CardNumber {
            static let font: UIFont = .rounded(ofSize: 20, weight: .bold)
            static let textColor: UIColor = .systemBlue
        }
    }
    
    // MARK: - Properties
    private var viewModel: DefinitionViewModel?
    private let ttsWorker: TextToSpeechWorkerProtocol = ElevenLabsWorker()
    private var exampleExpanded: Bool = false
    
    // MARK: - UI Elements
    private let wordClassContainer: UIView = UIView()
    private let wordClassLabel: UILabel = UILabel()
    private let definitionLabel: UILabel = UILabel()
    private let exampleView: UIView = UIView()
    private let playButton: UIButton = UIButton()
    private let cardCounter: UILabel = UILabel()
    private let exampleTextLabel: UILabel = UILabel()
    
    //MARK: - Constraints
    var exampleViewHeightConstraint: NSLayoutConstraint?
    var exampleViewWidthConstraint: NSLayoutConstraint?
    
    // MARK: - Initializers
    override init() {
        super.init()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    override func configure(with viewModel: CardFaceViewModel) {
        guard let viewModel = viewModel as? DefinitionViewModel else { return }

        wordClassLabel.text = viewModel.wordClass
        
        let firstPart = NSMutableAttributedString(string: "def: ", attributes: [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor.systemGray
        ])
        
        let secondPart = NSAttributedString(string: viewModel.definition, attributes: [
            .font: Constants.DefinitionLabel.font
        ])
        
        firstPart.append(secondPart)
        definitionLabel.attributedText = firstPart
        
        self.viewModel = viewModel
        
        if exampleExpanded {
            hideExample()
        }
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureWordClassLabel()
        configureDefinitionLabel()
        configureSoundButton()
        configureCardCounter()
        configureExampleView()
    }
    
    private func configureWordClassLabel() {
        wordClassLabel.font = Constants.WordClassLabel.font
        wordClassLabel.textColor = Constants.WordClassLabel.textColor
        wordClassLabel.textAlignment = .center
        
        wordClassContainer.addSubview(wordClassLabel)
        wordClassLabel.pinTop(to: wordClassContainer.layoutMarginsGuide.topAnchor)
        wordClassLabel.pinBottom(to: wordClassContainer.layoutMarginsGuide.bottomAnchor)
        wordClassLabel.pinLeft(to: wordClassContainer.layoutMarginsGuide.leadingAnchor)
        wordClassLabel.pinRight(to: wordClassContainer.layoutMarginsGuide.trailingAnchor)
        
        wordClassContainer.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        wordClassContainer.backgroundColor = Constants.WordClassLabel.backgroundColor
        wordClassContainer.layer.cornerRadius = Constants.WordClassLabel.size.height / 2
        
        addSubview(wordClassContainer)
        wordClassContainer.setHeight(Constants.WordClassLabel.size.height)
        wordClassContainer.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        wordClassContainer.pinTop(to: layoutMarginsGuide.topAnchor)
    }
    
    private func configureDefinitionLabel() {
        definitionLabel.numberOfLines = 0
        
        addSubview(definitionLabel)
        definitionLabel.pinTop(to: wordClassLabel.bottomAnchor, Constants.DefinitionLabel.offset)
        definitionLabel.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        definitionLabel.pinRight(to: layoutMarginsGuide.trailingAnchor)
    }
    
    private func configureExampleView() {
        exampleView.layoutMargins = Constants.ExampleView.insets
        
        exampleTextLabel.numberOfLines = 0
        exampleTextLabel.font = Constants.ExampleView.Text.font
        exampleTextLabel.textColor = Constants.ExampleView.Text.color
        exampleView.addSubview(exampleTextLabel)
        exampleTextLabel.pinLeft(to: exampleView.layoutMarginsGuide.leadingAnchor)
        exampleTextLabel.pinRight(to: exampleView.layoutMarginsGuide.trailingAnchor)
        exampleTextLabel.pinTop(to: exampleView.layoutMarginsGuide.topAnchor)
        
        let iconView = UIImageView(image: UIImage(systemName: "sparkles")?.withTintColor(Constants.ExampleView.iconColor))
        iconView.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(exampleViewTapped))
        exampleView.addGestureRecognizer(tapGestureRecognizer)
        
        exampleView.addSubview(iconView)
        iconView.setWidth(35)
        iconView.setHeight(35)
        iconView.pinRight(to: exampleView, 7.5)
        iconView.pinBottom(to: exampleView, 7.5)
        
        exampleView.backgroundColor = Constants.ExampleView.backgroundColor
        exampleView.layer.cornerRadius = Constants.ExampleView.cornerRadius
        exampleView.layer.borderColor = Constants.ExampleView.iconColor.cgColor
        exampleView.layer.borderWidth = Constants.ExampleView.borderWidth
        exampleView.clipsToBounds = true
        
        addSubview(exampleView)
        exampleView.translatesAutoresizingMaskIntoConstraints = false
        exampleViewWidthConstraint = exampleView.widthAnchor.constraint(equalToConstant: Constants.ExampleView.size.width)
        exampleViewHeightConstraint = exampleView.heightAnchor.constraint(equalToConstant: Constants.ExampleView.size.height)
        exampleViewWidthConstraint?.isActive = true
        exampleViewHeightConstraint?.isActive = true
        exampleView.pinRight(to: layoutMarginsGuide.trailingAnchor)
        exampleView.pinBottom(to: playButton.topAnchor, Constants.ExampleView.offset)
    }
    
    private func configureSoundButton() {
        playButton.setImage(UIImage(systemName: "speaker.wave.2.circle.fill"), for: .normal)
        playButton.contentVerticalAlignment = .fill
        playButton.contentHorizontalAlignment = .fill
        playButton.addTarget(self, action: #selector(playSound), for: .touchUpInside)
        addSubview(playButton)
        playButton.setWidth(Constants.SoundButton.size)
        playButton.setHeight(Constants.SoundButton.size)
        playButton.pinRight(to: layoutMarginsGuide.trailingAnchor)
        playButton.pinBottom(to: layoutMarginsGuide.bottomAnchor)
    }
    
    private func configureCardCounter() {
        cardCounter.font = Constants.CardNumber.font
        cardCounter.textColor = Constants.CardNumber.textColor
        addSubview(cardCounter)
        cardCounter.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        cardCounter.pinCenterY(to: playButton)
    }
    
    // MARK: - Button Targets
    @objc private func playSound() {
        guard let viewModel = viewModel else { return }
        ttsWorker.playSpeech(for: viewModel.word) { [weak self] result in
            switch result {
            case .success():
                break
            case .failure(_):
                self?.playButton.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
            }
        }
    }
    
    @objc private func exampleViewTapped() {
        if exampleExpanded {
            hideExample()
            return
        }
        
        guard let viewModel = viewModel else { return }
        MistralWorker.shared.getExampleSentence(for: viewModel.word, meaning: viewModel.definition) { result in
            switch result {
            case .success(let example):
                DispatchQueue.main.async {
                    self.showExample(example)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Animations
    private func showExample(_ example: String) {
        exampleViewWidthConstraint?.isActive = false
        exampleViewWidthConstraint = exampleView.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor)
        exampleViewWidthConstraint?.isActive = true
        
        exampleViewHeightConstraint?.isActive = false
        exampleViewHeightConstraint = exampleView.topAnchor.constraint(equalTo: definitionLabel.bottomAnchor, constant: 10)
        exampleViewHeightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
            self.exampleTextLabel.text = example
        } completion: { _ in
            self.exampleExpanded.toggle()
        }
    }
    
    private func hideExample() {
        exampleViewWidthConstraint?.isActive = false
        exampleViewWidthConstraint = exampleView.widthAnchor.constraint(equalToConstant: 50)
        exampleViewWidthConstraint?.isActive = true
        
        exampleViewHeightConstraint?.isActive = false
        exampleViewHeightConstraint = exampleView.heightAnchor.constraint(equalToConstant: 50)
        exampleViewHeightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
            self.exampleTextLabel.text = nil
            self.layoutIfNeeded()
        } completion: { _ in
            self.exampleExpanded.toggle()
        }
    }
}
