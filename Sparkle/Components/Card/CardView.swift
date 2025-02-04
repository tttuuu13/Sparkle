//
//  inputCard.swift
//  Sparkle
//
//  Created by тимур on 08.01.2025.
//

import UIKit

class CardView<Front: UIView & ConfigurableView, Back: UIView & ConfigurableView>: UIView, ConfigurableView {
    // MARK: - Fields
    var frontView: Front = Front()
    var backView: Back = Back()
    var isFlipped: Bool = false
    
    // MARK: - Initializers
    init(isFlipped: Bool) {
        super.init(frame: .zero)
        self.isFlipped = isFlipped
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with models: (Front.Model, Back.Model)) {
        frontView.configure(with: models.0)
        backView.configure(with: models.1)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {        
        layer.cornerRadius = Constants.cornerRadius
        
        frontView.layer.cornerRadius = Constants.cornerRadius
        addSubview(frontView)
        frontView.pinVertical(to: self)
        frontView.pinHorizontal(to: self)
        
        backView.layer.cornerRadius = Constants.cornerRadius
        addSubview(backView)
        backView.pinVertical(to: self)
        backView.pinHorizontal(to: self)
        
        if isFlipped {
            frontView.transform = CGAffineTransform(scaleX: -1, y: 1)
            frontView.isHidden = true
        } else {
            backView.transform = CGAffineTransform(scaleX: -1, y: 1)
            backView.isHidden = true
        }
    }
    
    // MARK: - Animated Card Flip
    func flip(completion: @escaping () -> Void) {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 3000
        
        UIView.animate(withDuration: Constants.flipDuration, delay: 0, options: [.curveEaseIn], animations: {
            self.layer.transform = CATransform3DRotate(transform, CGFloat.pi / 2, 0, 1, 0)
        }) { _ in
            self.frontView.isHidden.toggle()
            self.backView.isHidden.toggle()
            
            UIView.animate(withDuration: Constants.flipDuration, delay: 0, options: [.curveEaseOut]) {
                self.layer.transform = CATransform3DRotate(transform, self.isFlipped ? CGFloat.pi : 0, 0, 1, 0)
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
    static let flipDuration: TimeInterval = 0.3
}

#Preview {
    let view = CardView<TranslationView, TranslationView>(isFlipped: true)
    view.configure(with: (TranslationModel(text: "яблоко"), TranslationModel(text: "яблоко")))
    return view
}
