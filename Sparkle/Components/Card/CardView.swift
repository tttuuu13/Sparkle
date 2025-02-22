//
//  inputCard.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

protocol ConfigurableView: UIView {
    func configure(with model: Any)
}

class CardView: UIView {
    // MARK: - Fields
    var frontView: (any UIView & ConfigurableView)?
    var backView: (any UIView & ConfigurableView)?
    var isFlipped: Bool = false
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Constants.cornerRadius
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with models: (Any, Any?)) {
        frontView?.configure(with: models.0)
        if let backModel = models.1 {
            backView?.configure(with: backModel)
        }
    }
    
    func setFrontView(to view: any UIView & ConfigurableView) {
        frontView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        addSubview(view)
        view.pinVertical(to: self)
        view.pinHorizontal(to: self)
        if isFlipped {
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            view.isHidden = true
        }
        
        self.frontView = view
    }
    
    func setBackView(to view: any UIView & ConfigurableView) {
        backView?.removeFromSuperview()
        view.layer.cornerRadius = Constants.cornerRadius
        addSubview(view)
        view.pinVertical(to: self)
        view.pinHorizontal(to: self)
        if !isFlipped {
            view.transform = CGAffineTransform(scaleX: -1, y: 1)
            view.isHidden = true
        }
        backView = view
    }
    
    // MARK: - Animated Card Flip
    func flip(completion: @escaping () -> Void) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 3000
        
        UIView.animate(withDuration: Constants.flipDuration / 2, delay: 0, options: .curveEaseIn) {
            self.layer.transform = CATransform3DRotate(transform, .pi / 2, 0, 1, 0)
        } completion: { _ in
            self.frontView?.isHidden.toggle()
            self.backView?.isHidden.toggle()
            
            UIView.animate(withDuration: Constants.flipDuration / 2, delay: 0, options: .curveEaseOut) {
                self.layer.transform = CATransform3DRotate(transform, self.isFlipped ? 0 : .pi, 0, 1, 0)
            } completion: { _ in
                self.isFlipped.toggle()
                completion()
            }
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let cornerRadius: CGFloat = 25
    static let flipDuration: TimeInterval = 1
}
