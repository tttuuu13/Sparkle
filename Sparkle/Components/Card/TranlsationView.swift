//
//  TranlsationView.swift
//  Sparkle
//
//  Created by тимур on 04.02.2025.
//

import UIKit
import AVFoundation

struct TranslationViewModel: CardFaceViewModel {
    let word: String
    let transcription: String
    let translation: String
}

struct Counter {
    var current: Int
    var total: Int
}

// MARK: - Translation View
final class TranslationView: CardFaceView {
    // MARK: - Constants
    private enum Constants {
        enum TextLabel {
            static let font: UIFont = .systemFont(ofSize: 30, weight: .medium)
            static let offset: CGFloat = 10
        }
        
        enum TranscriptionLabel {
            static let font: UIFont = .systemFont(ofSize: 25, weight: .medium)
            static let textColor: UIColor = .secondaryLabel
            static let offset: CGFloat = 5
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
    private var viewModel: TranslationViewModel?
    private let ttsWorker: TextToSpeechWorkerProtocol = ElevenLabsWorker()

    // MARK: - UI Elements
    private let textLabel: UILabel = UILabel()
    private let transcriptionLabel: UILabel = UILabel()
    private let playButton: UIButton = UIButton()
    private let cardCounter: UILabel = UILabel()
    
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
        guard let viewModel = viewModel as? TranslationViewModel else { return }

        textLabel.text = viewModel.translation
        transcriptionLabel.text = viewModel.transcription

        self.viewModel = viewModel
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        configureTextLabel()
        configureTranscriptionLabel()
        configureSoundButton()
        configureCardCounter()
    }
    
    private func configureTextLabel() {
        textLabel.font = Constants.TextLabel.font
        addSubview(textLabel)
        textLabel.pinCenterX(to: self)
        textLabel.pinCenterY(to: self, -Constants.TextLabel.offset)
    }
    
    private func configureTranscriptionLabel() {
        transcriptionLabel.font = Constants.TranscriptionLabel.font
        transcriptionLabel.textColor = Constants.TranscriptionLabel.textColor
        addSubview(transcriptionLabel)
        transcriptionLabel.pinCenterX(to: self)
        transcriptionLabel.pinTop(to: textLabel.bottomAnchor, Constants.TranscriptionLabel.offset)
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
}
