//
//  inputCard.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

// MARK: - ConfigurableView Protocol
protocol ConfigurableView {
    func configure(with model: WordModel)
}

class CardView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 25
        static let flipDuration: TimeInterval = 0.5
    }

    // MARK: - Properties
    var model: WordModel?
    var isFlipped: Bool = false
    var frontView: (any UIView & ConfigurableView)? {
        get { _frontView }
    }

    var backView: (any UIView & ConfigurableView)? {
        get { _backView } 
    }
    // MARK: - UI Elements
    private let container: UIView = UIView()
    private let smartShuffleIcon: UIImageView = UIImageView(image: UIImage(systemName: "sparkles"))
    private var _frontView: (any UIView & ConfigurableView)?
    private var _backView: (any UIView & ConfigurableView)?
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.cornerRadius
        container.layer.cornerRadius = Constants.cornerRadius
        addSubview(container)
        container.pinWidth(to: self)
        container.pinHeight(to: self)
        
        container.addSubview(smartShuffleIcon)
        smartShuffleIcon.setWidth(50)
        smartShuffleIcon.setHeight(50)
        smartShuffleIcon.pinLeft(to: container, 20)
        smartShuffleIcon.pinBottom(to: container.bottomAnchor, 20)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with model: WordModel) {
        _frontView?.configure(with: model)
        _backView?.configure(with: model)

        if model.isSmartShuffle {
            container.layer.borderColor = UIColor.systemBlue.cgColor
            container.layer.borderWidth = 1
            smartShuffleIcon.isHidden = false
        } else {
            container.layer.borderColor = nil
            container.layer.borderWidth = 0
            smartShuffleIcon.isHidden = true
        }

        self.model = model
    }
    
    func prepareForReuse() {
        if isFlipped {
            flip(animated: false)
        }
        
        container.layer.borderColor = nil
        container.layer.borderWidth = 0
    }
    
    // MARK: - Setting Views
    func setFrontView(to view: any UIView & ConfigurableView) {
        _frontView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        container.addSubview(view)
        view.pinVertical(to: container)
        view.pinHorizontal(to: container)
        if isFlipped {
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            view.isHidden = true
        }
        
        _frontView = view
    }
    
    func setBackView(to view: any UIView & ConfigurableView) {
        _backView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        container.addSubview(view)
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
