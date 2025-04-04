//
//  GraphTile.swift
//  Sparkle
//
//  Created by тимур on 10.03.2025.
//

import UIKit

struct GraphTileViewModel {
    let number: Int
    let secondaryLabelText: String?
    let text: String
    let data: [Double]
    let backgroundColor: UIColor
    let mainColor: UIColor
}
    
final class GraphTile: UIView {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let cornerRadius: CGFloat = 16
            static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        enum TitleLabel {
            static let font: UIFont = .rounded(ofSize: 16, weight: .black)
            static let textAlignment: NSTextAlignment = .left
        }
        
        enum NumberLabel {
            static let font: UIFont = .rounded(ofSize: 36, weight: .black)
            static let textAlignment: NSTextAlignment = .left
        }
        
        enum SecondaryLabel {
            static let font: UIFont = .rounded(ofSize: 14, weight: .black)
            static let textAlignment: NSTextAlignment = .center
            static let borderWidth: CGFloat = 1
            static let cornerRadius: CGFloat = 10
            static let size: CGSize = CGSize(width: 40, height: 20)
        }
    }
    
    // MARK: - UI Elements
    private let numberLabel = UILabel()
    private let secondaryLabel = UILabel()
    private let titleLabel = UILabel()
    private let graphView = GraphView()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with viewModel: GraphTileViewModel) {
        backgroundColor = viewModel.backgroundColor
        numberLabel.text = "\(viewModel.number)"
        numberLabel.textColor = viewModel.mainColor
        layer.borderColor = viewModel.mainColor.cgColor
        layer.borderWidth = 1
        titleLabel.text = viewModel.text
        titleLabel.textColor = viewModel.mainColor
        graphView.configure(data: viewModel.data, color: viewModel.mainColor)
        
        if let secondaryLabelText = viewModel.secondaryLabelText {
            secondaryLabel.text = secondaryLabelText
            secondaryLabel.textColor = viewModel.mainColor
            secondaryLabel.layer.borderColor = viewModel.mainColor.cgColor
            secondaryLabel.isHidden = false
        }
    }
        
    
    // MARK: - UI Configuration
    private func configureUI() {
        layer.cornerRadius = Constants.View.cornerRadius
        layoutMargins = Constants.View.insets
        configureNumberLabel()
        configureTitleLabel()
        configureGraphView()
        configureSecondaryLabel()
    }
        
    private func configureNumberLabel() {
        numberLabel.font = Constants.NumberLabel.font
        numberLabel.textAlignment = Constants.NumberLabel.textAlignment
        
        addSubview(numberLabel)
        numberLabel.pinTop(to: layoutMarginsGuide.topAnchor)
        numberLabel.pinLeft(to: layoutMarginsGuide.leadingAnchor)
    }
    
    private func configureTitleLabel() {
        titleLabel.font = Constants.TitleLabel.font
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = Constants.TitleLabel.textAlignment
        
        addSubview(titleLabel)
        titleLabel.pinTop(to: numberLabel.bottomAnchor, -5)
        titleLabel.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        titleLabel.pinRight(to: layoutMarginsGuide.trailingAnchor)
    }
    
    private func configureGraphView() {
        addSubview(graphView)
        graphView.pinTop(to: titleLabel.bottomAnchor, 5)
        graphView.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        graphView.pinRight(to: layoutMarginsGuide.trailingAnchor)
        graphView.pinBottom(to: layoutMarginsGuide.bottomAnchor)
    }
    
    private func configureSecondaryLabel() {
        secondaryLabel.font = Constants.SecondaryLabel.font
        secondaryLabel.textAlignment = Constants.SecondaryLabel.textAlignment
        secondaryLabel.layer.borderWidth = Constants.SecondaryLabel.borderWidth
        secondaryLabel.layer.cornerRadius = Constants.SecondaryLabel.cornerRadius
        secondaryLabel.isHidden = true
        
        addSubview(secondaryLabel)
        secondaryLabel.pinCenterY(to: numberLabel)
        secondaryLabel.pinLeft(to: numberLabel.trailingAnchor, 5)
        secondaryLabel.setWidth(Constants.SecondaryLabel.size.width)
        secondaryLabel.setHeight(Constants.SecondaryLabel.size.height)
    }
}

@available(iOS 17.0, *)
#Preview {
    let view = GraphTile()
    let viewModel = GraphTileViewModel(number: 120, secondaryLabelText: "+40", text: "слов выучено", data: [0, 30, 80, 120], backgroundColor: .systemGreen.withAlphaComponent(0.15), mainColor: .systemGreen)
    view.configure(with: viewModel)
    view.setWidth(180)
    view.setHeight(180)
    return view
}
