//
//  FireCounter.swift
//  Sparkle
//
//  Created by тимур on 29.12.2024.
//

import UIKit

final class StreakFlame: UIView {
    // MARK: - Fields
    private let shapeLayer: CAShapeLayer = CAShapeLayer()
    private let counterLabel: UILabel = UILabel()
    public var counter: Int = 12
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureFlame()
        configureCounter()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Flame Configuration
    private func configureFlame() {
        shapeLayer.path = createFlamePath().cgPath
        shapeLayer.fillColor = Constants.Flame.fillColor.cgColor
        layer.addSublayer(shapeLayer)
        
        setWidth(61)
        setHeight(76)
    }
    
    // MARK: - Counter Configuration
    private func configureCounter() {
        addSubview(counterLabel)
        counterLabel.text = String(counter)
        counterLabel.font = Constants.Counter.font
        counterLabel.textColor = Constants.Counter.color
        counterLabel.layer.shadowColor = Constants.Counter.color.cgColor
        counterLabel.layer.shadowOffset = Constants.Counter.shadowOffset
        counterLabel.layer.shadowOpacity = Constants.Counter.shadowOpacity
        
        
        counterLabel.pinCenterX(to: self)
        counterLabel.pinCenterY(to: self, 10)
    }
    
    // MARK: - Creating Flame Path
    private func createFlamePath(offset: CGFloat = 0, offset2: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 30.52, y: 75.43))
        path.addCurve(to: CGPoint(x: 0.02, y: 49.93), controlPoint1: CGPoint(x: 10.52, y: 75.43), controlPoint2: CGPoint(x: -0.29, y: 59.5))
        path.addCurve(to: CGPoint(x: 3.02 + offset2, y: 14.43), controlPoint1: CGPoint(x: 0.52 + offset2, y: 34.43), controlPoint2: CGPoint(x: 1.82 + offset2, y: 19.63))
        path.addCurve(to: CGPoint(x: 11.02 + offset2, y: 10.43), controlPoint1: CGPoint(x: 4.22 + offset2, y: 9.23), controlPoint2: CGPoint(x: 8.85 + offset2, y: 9.6))
        path.addLine(to: CGPoint(x: 16.52, y: 14.43))
        path.addCurve(to: CGPoint(x: 24.52 + offset, y: 2.43), controlPoint1: CGPoint(x: 17.68 + offset, y: 12.26), controlPoint2: CGPoint(x: 20.92 + offset, y: 6.83))
        path.addCurve(to: CGPoint(x: 34.02 + offset, y: 2.43), controlPoint1: CGPoint(x: 28.12 + offset, y: -1.97), controlPoint2: CGPoint(x: 32.35 + offset, y: 0.6))
        path.addCurve(to: CGPoint(x: 55.52, y: 28.43), controlPoint1: CGPoint(x: 38.82, y: 7.95), controlPoint2: CGPoint(x: 55.52, y: 28.43))
        path.addCurve(to: CGPoint(x: 61.02, y: 43.93), controlPoint1: CGPoint(x: 61.52, y: 36.93), controlPoint2: CGPoint(x: 61.02, y: 43.93))
        path.addCurve(to: CGPoint(x: 30.52, y: 75.43), controlPoint1: CGPoint(x: 61.02, y: 54.43), controlPoint2: CGPoint(x: 55.52, y: 75.43))
        path.close()
        
        return path
    }
    
    // MARK: - Constants
    private struct Constants {
        struct Flame {
            static let fillColor: UIColor = UIColor(red: 1, green: 149 / 255, blue: 0, alpha: 1)
        }
        
        struct Counter {
            static let font: UIFont = .rounded(ofSize: 32, weight: .black)
            static let color: UIColor = UIColor(red: 1, green: 204 / 255, blue: 0, alpha: 1)
            static let shadowOffset: CGSize = .zero
            static let shadowOpacity: Float = 1
        }
    }
}

#Preview {
    let flame = StreakFlame()
    return flame
}
