//
//  CardStackView.swift
//  Sparkle
//
//  Created by тимур on 31.01.2025.
//

import Foundation
import UIKit

final class CardStackView: UIView {
    // MARK: - Fields
    private var mode: SearchMode = .translation
    private var showingViews: [CardView] = []
    private var models: [(Any, Any?)] = []
    private var topCardPosition: CGPoint = .zero
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private var topCardIndex = 0
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with models: [(Any, Any?)], mode: SearchMode = .translation) {
        topCardIndex = 0
        showingViews.forEach { $0.removeFromSuperview() }
        showingViews = []
        self.models = models
        self.mode = mode
        models[..<min(Constants.StackView.cardsToShow, models.count)].forEach { model in
            let card = CardView()
            card.setFrontView(to: self.mode == .translation ? TranslationView() : DefinitionView())
            card.configure(with: model)
            insertSubview(card, at: 0)
            showingViews.append(card)
            card.pinWidth(to: self)
            card.pinHeight(to: card.widthAnchor)
            card.pinCenterX(to: self)
            card.pinTop(to: self)
        }
        
        if let topCard = showingViews.first {
            topCard.addGestureRecognizer(panGestureRecognizer)
        }
    }

    // MARK: - Public Methods
    func getTopCardModel() -> (Any, Any?) {
        return models[topCardIndex % models.count]
    }
    
    // MARK: - Gesture Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? CardView else { return }
        let translation = gesture.translation(in: self)
        let offsetX = card.center.x - topCardPosition.x
        
        switch gesture.state {
        case .began:
            startDrugging(card)
            
        case .changed:
            moveCard(card, translation: translation, offsetX: offsetX)
            gesture.setTranslation(.zero, in: self)
            
        case .ended:
            endDrugging(card, offsetX: offsetX)
            
        default:
            break
        }
    }
    
    private func startDrugging(_ card: CardView) {
        topCardPosition = card.center
        UIView.animate(withDuration: 0.2) {
            card.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func moveCard(_ card: CardView, translation: CGPoint, offsetX: CGFloat) {
        card.center = CGPoint(x: card.center.x + translation.x * 2, y: card.center.y + translation.y * 0.3)
        card.transform = CGAffineTransform(rotationAngle: offsetX / 500).scaledBy(x: 1.05, y: 1.05)
    }
    
    private func endDrugging(_ card: CardView, offsetX: CGFloat) {
        if abs(offsetX) > 200 && showingViews.count > 1 {
            swipeTopCardToBack(card)
        } else {
            returnCardToOriginalPosition(card)
        }
    }
    
    private func swipeTopCardToBack(_ card: CardView) {
        topCardIndex += 1
        card.removeGestureRecognizer(panGestureRecognizer)
        let topCard = showingViews[topCardIndex % showingViews.count]
        topCard.addGestureRecognizer(panGestureRecognizer)
        
        for i in topCardIndex..<topCardIndex + showingViews.count {
            UIView.animate(withDuration: 0.5) { [self] in
                sendSubviewToBack(card)
                showingViews[i % showingViews.count].transform = CGAffineTransform(translationX: 0, y: CGFloat(25 * (i - topCardIndex))).scaledBy(x: 1 - 0.1 * CGFloat(i - topCardIndex), y: 1 - 0.1 * CGFloat(i - topCardIndex))
                card.center.x = topCardPosition.x
            } completion: { [self] _ in
                card.configure(with: models[(topCardIndex + showingViews.count - 1) % models.count])
            }
        }
    }
    
    private func returnCardToOriginalPosition(_ card: CardView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            card.transform = .identity
            card.center = self.topCardPosition
        })
    }
    
    // MARK: - Animations
    func expand(completion: @escaping (() -> Void) = {}) {
        for i in 0..<showingViews.count {
            let card = showingViews[i]
            card.layer.shadowOpacity = Constants.Card.shadowOpacity / Float(showingViews.count)
            card.layer.shadowRadius = Constants.Card.shadowRadius
            UIView.animate(withDuration: 0.5) {
                card.layer.shadowOpacity = Constants.Card.shadowOpacity
                card.transform = CGAffineTransform(translationX: 0, y: CGFloat(25 * CGFloat(i))).scaledBy(x: 1 - 0.1 * CGFloat(i), y: 1 - 0.1 * CGFloat(i))
            }
        }
    }
    
    func collapse(completion: @escaping (() -> Void) = {}) {
        if showingViews.isEmpty {
            completion()
            return
        }
        
        let group = DispatchGroup()
        for view in showingViews {
            group.enter()
            
            UIView.animate(withDuration: 0.5) {
                view.transform = .identity
                view.layer.shadowOpacity = Constants.Card.shadowOpacity / Float(self.showingViews.count)
            } completion: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
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

    enum Counter {
        static let font: UIFont = .rounded(ofSize: 20, weight: .bold)
        static let textColor: UIColor = .systemBlue
        static let offset: CGFloat = 10
    }
}
