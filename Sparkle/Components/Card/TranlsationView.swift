//
//  TranlsationView.swift
//  Sparkle
//
//  Created by тимур on 04.02.2025.
//

import UIKit
import AVFoundation

// MARK: - Translation Model
struct TranslationModel: CardFaceModel {
    var text: String
    var transcription: String?
    var audioURL: URL?
    var counter: Counter?
}

struct Counter {
    var current: Int
    var total: Int
}

// MARK: - Translation View
final class TranslationView: UIView, ConfigurableView {
    typealias Model = TranslationModel
    // MARK: - Fields
    private var audioURL: URL?
    
    // MARK: - UI Elements
    private let textLabel: UILabel = UILabel()
    private let transcriptionLabel: UILabel = UILabel()
    private let playButton: UIButton = UIButton()
    private let cardCounter: UILabel = UILabel()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with model: CardFaceModel) {
        guard let model = model as? TranslationModel else {
            print("View \(self) configured with wrong model type.")
            return
        }
        
        textLabel.text = model.text
        transcriptionLabel.text = model.transcription
        if let audioURL = model.audioURL {
            self.audioURL = audioURL
        }
        
        if let counter = model.counter {
            self.cardCounter.text = "\(counter.current)/\(counter.total)"
        }
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layoutMargins = Constants.View.insets
        backgroundColor = .white
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
        playButton.setImage(UIImage(systemName: "speaker.slash.circle.fill"), for: .normal)
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
        if let url = audioURL {
            let player = AVPlayer(url: url)
            player.play()
        }
    }
    
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
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
}

@available(iOS 17.0, *)
#Preview {
    let view = TranslationView()
    view.configure(with: TranslationModel(text: "яблоко"))
    return view
}
