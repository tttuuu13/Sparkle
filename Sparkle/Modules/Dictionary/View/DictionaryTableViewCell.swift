//
//  DictionaryTableViewCell.swift
//  Sparkle
//
//  Created by тимур on 12.03.2025.
//

import UIKit

class DictionaryTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    private let chart = UIImageView()
    private let wordLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureWordLabel()
        configureChart()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(with wordModel: WordModel) {
        wordLabel.text = wordModel.word
        
        switch wordModel.knowledgeLevel {
        case 0.25..<0.5: chart.image = UIImage(named: "chart.low")
        case 0.5..<0.75: chart.image = UIImage(named: "chart.half")
        case 0.75...: chart.image = UIImage(named: "chart.full")
        default: chart.image = UIImage(named: "chart.empty")
        }
    }
    
    // MARK: - UI Configuration
    private func configureWordLabel() {
        wordLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        contentView.addSubview(wordLabel)
        wordLabel.pinLeft(to: contentView.leadingAnchor, 20)
        wordLabel.pinCenterY(to: contentView)
    }

    private func configureChart() {
        chart.contentMode = .scaleAspectFit
        contentView.addSubview(chart)
        chart.pinRight(to: contentView.trailingAnchor, 20)
        chart.pinCenterY(to: contentView)
        chart.setWidth(20)
        chart.setHeight(30)
    }

}
