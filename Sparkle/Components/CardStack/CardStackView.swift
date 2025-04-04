//
//  CardStackView.swift
//  Sparkle
//
//  Created by тимур on 31.01.2025.
//

import Foundation
import UIKit

enum SwipeDirection {
    case left
    case right
}

protocol CardStackViewDelegate: AnyObject {
    func cardStack(_ cardStack: CardStackView, didSwipeCardIndex index: Int, in direction: SwipeDirection)
}

protocol CardStackViewDataSource: AnyObject {
    func numberOfCards(in cardStack: CardStackView) -> Int
    func cardStack(_ cardStack: CardStackView, cardViewModelAt index: Int) -> CardViewModel
}

final class CardStackView: UIView {
    // MARK: - Constants
    private enum Constants {
        enum StackView {
            static let cardsToShow: Int = 3
        }
        
        enum Card {
            static let shadowOpacity: Float = 0.1
            static let shadowRadius: CGFloat = 40
        }

        enum Counter {
            static let font: UIFont = .rounded(ofSize: 20, weight: .bold)
            static let textColor: UIColor = .systemBlue
            static let offset: CGFloat = 10
        }
    }

    // MARK: - Types
    enum SwipeMode {
        case cycle
        case remove
    }
    
    // MARK: - Properties
    weak var delegate: CardStackViewDelegate?
    weak var dataSource: CardStackViewDataSource?
    private(set) var currentCardIndex = 0
    private var swipeMode: SwipeMode
    private var showingViews: [Card] = []
    private var topCardPosition: CGPoint = .zero
    private var areCardsFlipped: Bool
    private var areCardsFlippable: Bool
    private var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    private var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    // MARK: - Initializers
    init(swipeMode: SwipeMode, areCardsFlipped: Bool = false, areCardsFlippable: Bool = true) {
        self.swipeMode = swipeMode
        self.areCardsFlipped = areCardsFlipped
        self.areCardsFlippable = areCardsFlippable
        super.init(frame: .zero)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 3000
        layer.sublayerTransform = perspective
    }
    
    // MARK: - Public Methods
    func configure(frontViewType: CardFaceType, backViewType: CardFaceType, swipeMode: SwipeMode, areCardsFlipped: Bool = false, areCardsFlippable: Bool = true) {
    }
    
    func reloadData(completion: @escaping (() -> Void) = {}) {
        guard let dataSource = dataSource else { return }
        
        for index in 0..<Constants.StackView.cardsToShow {
            if index + 1 > showingViews.count && index + 1 <= dataSource.numberOfCards(in: self) {
                let card = Card()
                let cardViewModel = dataSource.cardStack(self, cardViewModelAt: index)
                card.setFrontView(to: cardViewModel.createFrontView())
                card.setBackView(to: cardViewModel.createBackView())
                card.configure(with: cardViewModel)
                card.layer.shadowOpacity = Constants.Card.shadowOpacity / Float(Constants.StackView.cardsToShow)
                card.layer.shadowRadius = Constants.Card.shadowRadius
                insertSubview(card, at: 0)
                showingViews.append(card)
    
                card.pinWidth(to: self)
                card.pinHeight(to: card.widthAnchor)
                card.pinCenterX(to: self)
                card.pinTop(to: self)
            } else if index + 1 > dataSource.numberOfCards(in: self) && index + 1 <= showingViews.count {
                showingViews.removeLast().removeFromSuperview()
            }
        }

        if let topCard = showingViews.first {
            topCard.addGestureRecognizer(panGestureRecognizer)
            topCard.addGestureRecognizer(tapGestureRecognizer)
        }
        
        updateCardLayout()
    }
    
    func updateCardLayout() {
        guard let dataSource = dataSource else { return }

        for index in 0..<showingViews.count {
            let card = showingViews[index]
            let viewModel = dataSource.cardStack(self, cardViewModelAt: index)
            card.setFrontView(to: viewModel.createFrontView())
            card.configure(with: viewModel)
            UIView.animate(withDuration: 0.3) {
                card.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, CGFloat(25 * index), CGFloat(-300 * index))
                card.layer.shadowOpacity = Float(Constants.Card.shadowOpacity)
            }
        }
    }
    
    func getTopCardViewModel() -> CardViewModel? {
        guard let dataSource = dataSource else { return nil }
        return dataSource.cardStack(self, cardViewModelAt: 0)
    }
    
    // MARK: - Gesture Handling
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        if !areCardsFlippable {
            return
        }
        
        guard let card = gesture.view as? Card else { return }
        card.flip()
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let card = gesture.view as? Card else { return }
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
    
    private func startDrugging(_ card: Card) {
        topCardPosition = card.center
        UIView.animate(withDuration: 0.2) {
            card.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    private func moveCard(_ card: Card, translation: CGPoint, offsetX: CGFloat) {
        card.center = CGPoint(x: card.center.x + translation.x * 2, y: card.center.y + translation.y * 0.3)
        card.transform = CGAffineTransform(rotationAngle: offsetX / 500).scaledBy(x: 1.05, y: 1.05)
    }
    
    private func endDrugging(_ card: Card, offsetX: CGFloat) {
        if abs(offsetX) > 200 {
            if swipeMode == .cycle && showingViews.count > 1 {
                swipeTopCardToBack(card, direction: offsetX > 0 ? .right : .left)
            } else {
                removeCard(card, direction: offsetX > 0 ? .right : .left)
            }
        } else {
            returnCardToOriginalPosition(card)
        }
    }
    
    private func swipeTopCardToBack(_ card: Card, direction: SwipeDirection) {
        delegate?.cardStack(self, didSwipeCardIndex: currentCardIndex, in: direction)
        card.removeGestureRecognizer(panGestureRecognizer)
        card.removeGestureRecognizer(tapGestureRecognizer)
        
        UIView.animate(withDuration: 0.3, animations: { [self] in
            sendSubviewToBack(card)
            card.center = showingViews.last?.center ?? topCardPosition
            card.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, CGFloat(25), CGFloat(-900))
        }) { [self] _ in
            showingViews.append(showingViews.remove(at: 0))
            card.prepareForReuse()
            
            currentCardIndex += 1
            let newCard = showingViews.first
            newCard?.addGestureRecognizer(panGestureRecognizer)
            newCard?.addGestureRecognizer(tapGestureRecognizer)
            
            updateCardLayout()
        }
    }

    private func removeCard(_ card: Card, direction: SwipeDirection) {
        guard let dataSource = dataSource else { return }
        card.removeGestureRecognizer(panGestureRecognizer)
        card.removeGestureRecognizer(tapGestureRecognizer)

        UIView.animate(withDuration: 0.3, animations: {
            card.center = CGPoint(x: direction == .right ? 700 : -700, y: card.center.y)
        }) { [self] _ in
            if dataSource.numberOfCards(in: self) >= Constants.StackView.cardsToShow {
                sendSubviewToBack(card)
                card.center = showingViews.last?.center ?? topCardPosition
                card.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, CGFloat(25 * (showingViews.count - 1)), CGFloat(-300 * showingViews.count))
                card.layer.shadowOpacity = Constants.Card.shadowOpacity / 2
                card.prepareForReuse()
                showingViews.append(showingViews.remove(at: 0))
            } else {
                card.removeFromSuperview()
                showingViews.remove(at: 0)
            }
            
            delegate?.cardStack(self, didSwipeCardIndex: currentCardIndex, in: direction)
            
            if !showingViews.isEmpty {
                currentCardIndex += 1
                let newCard = showingViews.first
                newCard?.addGestureRecognizer(panGestureRecognizer)
                newCard?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    private func returnCardToOriginalPosition(_ card: Card) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: {
            card.transform = .identity
            card.center = self.topCardPosition
        })
    }
    
    // MARK: - Animations
    func collapse(completion: @escaping (() -> Void) = {}) {
        if showingViews.isEmpty {
            completion()
            return
        }
        
        let group = DispatchGroup()
        for card in showingViews {
            group.enter()
            
            UIView.animate(withDuration: 0.5) {
                card.transform3D = CATransform3DIdentity
                card.layer.shadowOpacity = Constants.Card.shadowOpacity / Float(self.showingViews.count)
            } completion: { _ in
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}
