import UIKit

final class StreakFlame: UIView {
    // MARK: - Constants
    private enum Constants {
        enum Flame {
            static let fillColor: UIColor = UIColor(red: 1, green: 149 / 255, blue: 0, alpha: 1)
            static let baseWidth: CGFloat = 61
            static let baseHeight: CGFloat = 76
        }
    }

    // MARK: - Properties
    static let aspectRatio = CGFloat(61) / CGFloat(76)
    private let shapeLayer: CAShapeLayer = CAShapeLayer()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureFlame()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Flame Configuration
    private func configureFlame() {
        shapeLayer.fillColor = Constants.Flame.fillColor.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        
        let scaleX = bounds.width / Constants.Flame.baseWidth
        let scaleY = bounds.height / Constants.Flame.baseHeight
        let scale = min(scaleX, scaleY)
        
        var transform = CGAffineTransform(scaleX: scale, y: scale)
        let path = createFlamePath().cgPath.copy(using: &transform)
        shapeLayer.path = path
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
}

@available(iOS 17.0, *)
#Preview {
    let flame = StreakFlame()
    flame.setWidth(100)
    flame.setHeight(100 / StreakFlame.aspectRatio)
    flame.layer.borderWidth = 1
    flame.layer.borderColor = UIColor.systemGray.cgColor
    return flame
}
