//
//  GraphView.swift
//  Sparkle
//
//  Created by тимур on 07.03.2025.
//

import UIKit

final class GraphView: UIView {
    private var dataPoints: [Double] = []
    private var color: UIColor?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data dataPoints: [Double], color: UIColor) {
        self.dataPoints = dataPoints
        self.color = color
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(), !dataPoints.isEmpty else { return }
        
        let width = rect.width
        let height = rect.height
        
        let verticalPadding: CGFloat = 2
        
        let maxVal = dataPoints.max() ?? 0
        
        let path = UIBezierPath()
        let graphHeight = height - (verticalPadding * 2)
        let graphBottom = height - verticalPadding
        
        for (index, point) in dataPoints.enumerated() {
            let x = width * CGFloat(index) / CGFloat(dataPoints.count - 1)
            
            let normalizedPoint = maxVal > 0 ? CGFloat(point / maxVal) : 0.5
            let y = graphBottom - normalizedPoint * graphHeight
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                let previousX = width * CGFloat(index - 1) / CGFloat(dataPoints.count - 1)
                let controlX1 = previousX + (x - previousX) / 2
                let controlX2 = previousX + (x - previousX) * 2 / 4
                
                let previousValue = dataPoints[index - 1]
                let previousNormalizedPoint = maxVal > 0 ? CGFloat(previousValue / maxVal) : 0.5
                let previousY = graphBottom - previousNormalizedPoint * graphHeight
                
                path.addCurve(to: CGPoint(x: x, y: y),
                              controlPoint1: CGPoint(x: controlX1, y: previousY),
                              controlPoint2: CGPoint(x: controlX2, y: y))
            }
        }
        
        color?.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        let fillPath = path.copy() as! UIBezierPath
        
        fillPath.addLine(to: CGPoint(x: width, y: graphBottom))
        fillPath.addLine(to: CGPoint(x: 0, y: graphBottom))
        fillPath.close()
    
        context.saveGState()
        fillPath.addClip()
        
        let colors = [color?.withAlphaComponent(0).cgColor, color?.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        if let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations) {
            context.drawLinearGradient(gradient,
                                      start: CGPoint(x: 0, y: graphBottom),
                                      end: CGPoint(x: 0, y: graphBottom - graphHeight),
                                      options: [])
        }
        context.restoreGState()
    }
}
