//
//  inputCard.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

struct CardViewModel {
    let wordModel: WordModel
    var frontType: CardFaceType
    var backType: CardFaceType
    var isFlipped: Bool = false
    var isSmartShuffle: Bool = false

    func createFrontViewModel() -> CardFaceViewModel {
        createViewModel(for: frontType)
    }
    
    func createBackViewModel() -> CardFaceViewModel {
        createViewModel(for: backType)
    }
    
    func createFrontView() -> CardFaceView {
        switch frontType {
        case .word:
            return WordView()
        case .search:
            return SearchView()
        case .definition:
            return DefinitionView()
        case .translation:
            return TranslationView()
        }
    }
    
    func createBackView() -> CardFaceView {
        switch backType {
        case .word:
            return WordView()
        case .search:
            return SearchView()
        case .definition:
            return DefinitionView()
        case .translation:
            return TranslationView()
        }
    }
    
    private func createViewModel(for type: CardFaceType) -> CardFaceViewModel {
        switch type {
        case .word:
            return WordViewModel(word: wordModel.word)
        case .search:
            return SearchViewModel(word: wordModel.word, mode: .translation)
        case .definition:
            return DefinitionViewModel(word: wordModel.word, wordClass: wordModel.partOfSpeech, definition: wordModel.definition)
        case .translation:
            return TranslationViewModel(word: wordModel.word, transcription: wordModel.transcription, translation: wordModel.translation)
        }
    }
}

final class Card: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let flipDuration: TimeInterval = 0.5
    }

    // MARK: - Properties
    var viewModel: CardViewModel?
    var isFlipped: Bool = false
    var frontView: CardFaceView? {
        get { _frontView }
    }

    var backView: CardFaceView? {
        get { _backView }
    }
    
    private var frontViewType: CardFaceType?
    private var backViewType: CardFaceType?
    // MARK: - UI Elements
    private let container: UIView = UIView()
    private let smartShuffleIcon: UIImageView = UIImageView(image: UIImage(systemName: "sparkles"))
    private var _frontView: CardFaceView?
    private var _backView: CardFaceView?
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.cornerRadius
        container.layer.cornerRadius = Constants.cornerRadius
        addSubview(container)
        container.pinWidth(to: self)
        container.pinHeight(to: self)
        
        smartShuffleIcon.isHidden = true
        container.addSubview(smartShuffleIcon)
        smartShuffleIcon.setWidth(30)
        smartShuffleIcon.setHeight(35)
        smartShuffleIcon.pinLeft(to: container.leadingAnchor, 20)
        smartShuffleIcon.pinBottom(to: container.bottomAnchor, 20)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with viewModel: CardViewModel) {
        if viewModel.isFlipped {
            flip(animated: false)
            isFlipped = true
        }
        
        _frontView?.configure(with: viewModel.createFrontViewModel())
        _backView?.configure(with: viewModel.createBackViewModel())

        if viewModel.isSmartShuffle {
            container.layer.borderColor = UIColor.systemBlue.cgColor
            container.layer.borderWidth = 1
            smartShuffleIcon.isHidden = false
        } else {
            container.layer.borderColor = nil
            container.layer.borderWidth = 0
            smartShuffleIcon.isHidden = true
        }

        self.viewModel = viewModel
    }
    
    func prepareForReuse() {
        if isFlipped {
            flip(animated: false)
        }
        
        container.layer.borderColor = nil
        container.layer.borderWidth = 0
    }
    
    // MARK: - Setting Views
    func setFrontView(to view: CardFaceView) {
        _frontView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        container.insertSubview(view, at: 0)
        view.pinVertical(to: container)
        view.pinHorizontal(to: container)
        if isFlipped {
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            view.isHidden = true
        }
        
        _frontView = view
    }
    
    func setBackView(to view: CardFaceView) {
        _backView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        container.insertSubview(view, at: 0)
        view.pinVertical(to: container)
        view.pinHorizontal(to: container)
        if !isFlipped {
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            view.isHidden = true
        }
        
        _backView = view
    }
    
    // MARK: - Animated Card Flip
    func flip(animated: Bool = true, completion: @escaping () -> Void = {}) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 3000
        
        let animationDuration = animated ? Constants.flipDuration / 2 : 0
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn) {
            self.container.layer.transform = CATransform3DRotate(transform, .pi / 2, 0, 1, 0)
        } completion: { _ in
            self._frontView?.isHidden.toggle()
            self._backView?.isHidden.toggle()
            
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                self.container.layer.transform = CATransform3DRotate(transform, self.isFlipped ? 0 : .pi, 0, 1, 0)
            } completion: { _ in
                self.isFlipped.toggle()
                completion()
            }
        }
    }
}
