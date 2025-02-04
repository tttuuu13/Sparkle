//
//  CardStackView.swift
//  Sparkle
//
//  Created by тимур on 31.01.2025.
//

import Foundation
import UIKit

final class CardStackView<Front: UIView & ConfigurableView, Back: UIView & ConfigurableView>: UIView {
    // MARK: - Fields
    private var showingViews: [CardView<Front, Back>] = []
    private var models: [(Front.Model, Back.Model)] = []
    private let areFlipped: Bool
    private var topCardPosition: CGPoint = .zero
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private var topCardIndex = 0
    
    // MARK: - Initializers
    init(with models: [(Front.Model, Back.Model)], areFlipped: Bool = false) {
        self.models = models
        self.areFlipped = areFlipped
        super.init(frame: .zero)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - UI Configuration
    private func configureUI() {
        models[..<Constants.StackView.cardsToShow].forEach { model in
            addCard(model: model)
        }
        
        if let topCard = showingViews.first {
            topCard.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? CardView<Front, Back> else { return }
        let translation = gesture.translation(in: self)
        let offsetX = card.center.x - topCardPosition.x
        
        switch gesture.state {
        case .began:
            topCardPosition = card.center
            UIView.animate(withDuration: 0.2) {
                card.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
            
        case .changed:
            card.center = CGPoint(x: card.center.x + translation.x * 2, y: card.center.y + translation.y * 0.3)
            card.transform = CGAffineTransform(rotationAngle: offsetX / 500).scaledBy(x: 1.05, y: 1.05)
            gesture.setTranslation(.zero, in: self)
        case .ended:
            if abs(offsetX) > 200 {
                topCardIndex += 1
                card.removeGestureRecognizer(panGestureRecognizer)
                let topCard = showingViews[topCardIndex % Constants.StackView.cardsToShow]
                topCard.addGestureRecognizer(panGestureRecognizer)
                
                for i in topCardIndex..<topCardIndex + Constants.StackView.cardsToShow {
                    UIView.animate(withDuration: 0.5) { [self] in
                        sendSubviewToBack(card)
                        showingViews[i % Constants.StackView.cardsToShow].transform = CGAffineTransform(translationX: 0, y: CGFloat(25 * (i - topCardIndex))).scaledBy(x: 1 - 0.1 * CGFloat(i - topCardIndex), y: 1 - 0.1 * CGFloat(i - topCardIndex))
                        card.center.x = topCardPosition.x
                    } completion: { [self] _ in
                        card.configure(with: models[(topCardIndex + Constants.StackView.cardsToShow - 1) % models.count])
                    }
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
                    card.transform = .identity
                    card.center = self.topCardPosition
                })
            }
        default:
            break
        }
    }
    
    // MARK: - Animations
    private func addCard(model: (Front.Model, Back.Model)) {
        let card = CardView<Front, Back>(isFlipped: areFlipped)
        card.configure(with: model)
        card.layer.shadowOpacity = Constants.Card.shadowOpacity
        card.layer.shadowRadius = Constants.Card.shadowRadius
        insertSubview(card, at: 0)
        showingViews.append(card)
        card.pinWidth(to: self)
        card.pinHeight(to: card.widthAnchor)
        card.pinCenterX(to: self)
        card.pinTop(to: self)
        UIView.animate(withDuration: 0.5) { [self] in
            card.transform = CGAffineTransform(translationX: 0, y: CGFloat(25 * CGFloat((showingViews.count - 1)))).scaledBy(x: 1 - 0.1 * CGFloat(showingViews.count - 1), y: 1 - 0.1 * CGFloat(showingViews.count - 1))
        }
    }
}

// MARK: - Constants
fileprivate enum Constants {
    enum StackView {
        static let cardsToShow: Int = 3
    }
    
    enum Card {
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 45
    }
}


#Preview {
    let view = CardStackView<TranslationView, TranslationView>(with: [
        (TranslationModel(text: "яблоко"), TranslationModel(text: "яблоко")),
        (TranslationModel(text: "банан"), TranslationModel(text: "банан")),
        (TranslationModel(text: "апельсин"), TranslationModel(text: "апельсин")),
        (TranslationModel(text: "черешня"), TranslationModel(text: "черешня")),
        (TranslationModel(text: "груша"), TranslationModel(text: "груша"))
    ], areFlipped: true)
    view.setWidth(320)
    view.setHeight(450)
    return view
}
