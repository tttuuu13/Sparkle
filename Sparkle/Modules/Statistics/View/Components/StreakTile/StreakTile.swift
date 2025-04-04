//
//  StreakTile.swift
//  Sparkle
//
//  Created by тимур on 09.03.2025.
//

import UIKit

enum WeekDay: String, CaseIterable {
    case monday = "ПН"
    case tuesday = "ВТ"
    case wednesday = "СР"
    case thursday = "ЧТ"
    case friday = "ПТ"
    case saturday = "СБ"
    case sunday = "ВС"
    
    static func from(date: Date) -> WeekDay {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        
        guard let weekDay = components.weekday else { return .monday }
        
        switch weekDay {
        case 1:
            return .sunday
        case 2:
            return .monday
        case 3:
            return .tuesday
        case 4:
            return .wednesday
        case 5:
            return .thursday
        case 6:
            return .friday
        case 7:
            return .saturday
        default:
            return .monday
        }
    }
    
    static func current() -> WeekDay {
        return from(date: Date())
    }
}

enum DayState {
    case fire
    case active
    case inactive
}

final class StreakTile: UIView {
    // MARK: - Constants
    private enum Constants {
        static let insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        static let backgroundColor: UIColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 0.1)
        static let cornerRadius: CGFloat = 20
        static let borderWidth: CGFloat = 1
        static let borderColor: CGColor  = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 1).cgColor
        static let textColor: UIColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 1)
        
        enum MainText {
            static let font: UIFont = .rounded(ofSize: 20, weight: .black)
            static let textColor: UIColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 1)
            static let textAlignment: NSTextAlignment = .left
        }
        
        enum DayLabel {
            static let size: CGSize = CGSize(width: 40, height: 40)
            static let font: UIFont = .rounded(ofSize: 20, weight: .black)
            static let activeTextColor: UIColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 1)
            static let borderWidth: CGFloat = 1
            static let activeBorderColor: CGColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 1).cgColor
            static let activeBackgroundColor: UIColor = UIColor(red: 1, green: 150 / 255, blue: 0, alpha: 0.3)
            static let inactiveBorderColor: CGColor = UIColor.gray.withAlphaComponent(0.7).cgColor
            static let inactiveTextColor: UIColor = UIColor.gray.withAlphaComponent(0.7)
        }
        
        enum StreakFlameText {
            static let font: UIFont = .rounded(ofSize: 20, weight: .black)
            static let color: UIColor = UIColor(red: 1, green: 204 / 255, blue: 0, alpha: 1)
            static let shadowOffset: CGSize = .zero
            static let shadowOpacity: Float = 1
        }
    }
    
    // MARK: - UI Elements
    private let mainText = UILabel()
    private let bottomText = UILabel()
    private let streakDaysStack = UIStackView()
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Method
    func configure(activeDaysOfWeek: [WeekDay], today: WeekDay) {
        streakDaysStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for day in WeekDay.allCases {
            if day == today && activeDaysOfWeek.contains(day) {
                streakDaysStack.addArrangedSubview(createDayLabel(for: day, state: .fire))
            } else if activeDaysOfWeek.contains(day) {
                streakDaysStack.addArrangedSubview(createDayLabel(for: day, state: .active))
            } else {
                streakDaysStack.addArrangedSubview(createDayLabel(for: day, state: .inactive))
            }
        }
    }
    
    func setMainText(_ text: String) {
        mainText.text = text
    }
    
    func setBottomText(_ text: String) {
        let attributedString = NSMutableAttributedString()
        
        if let symbolImage = UIImage(systemName: "star.circle.fill")?.withTintColor(Constants.MainText.textColor) {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = symbolImage
            
            let fontSize = Constants.MainText.font.pointSize
            imageAttachment.bounds = CGRect(x: 0, y: -4, width: fontSize + 2, height: fontSize + 2)
            
            let imageString = NSAttributedString(attachment: imageAttachment)
            attributedString.append(imageString)
        }
        
        attributedString.append(NSAttributedString(string: " "))
        attributedString.append(NSAttributedString(string: text))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = Constants.MainText.textAlignment
        
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.font, value: Constants.MainText.font, range: range)
        attributedString.addAttribute(.foregroundColor, value: Constants.MainText.textColor, range: range)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        
        bottomText.attributedText = attributedString
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        layoutMargins = Constants.insets
        backgroundColor = Constants.backgroundColor
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Constants.borderColor
        configureMainText()
        configureBottomText()
        configureStreakDaysStack()
    }
    
    private func configureMainText() {
        mainText.font = Constants.MainText.font
        mainText.textColor = Constants.MainText.textColor
        mainText.textAlignment = Constants.MainText.textAlignment
        mainText.numberOfLines = 0
        
        addSubview(mainText)
        mainText.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        mainText.pinRight(to: layoutMarginsGuide.trailingAnchor)
        mainText.pinTop(to: layoutMarginsGuide.topAnchor)
    }

    private func configureBottomText() {
        bottomText.numberOfLines = 0
        
        addSubview(bottomText)
        bottomText.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        bottomText.pinRight(to: layoutMarginsGuide.trailingAnchor)
        bottomText.pinBottom(to: layoutMarginsGuide.bottomAnchor)
    }
    
    private func configureStreakDaysStack() {
        streakDaysStack.axis = .horizontal
        streakDaysStack.distribution = .equalSpacing
        streakDaysStack.alignment = .bottom
        
        addSubview(streakDaysStack)
        streakDaysStack.pinLeft(to: layoutMarginsGuide.leadingAnchor)
        streakDaysStack.pinRight(to: layoutMarginsGuide.trailingAnchor)
        streakDaysStack.pinTop(to: mainText.bottomAnchor)
        streakDaysStack.pinBottom(to: bottomText.topAnchor, 10)
    }
    
    private func createDayLabel(for day: WeekDay, state: DayState) -> UIView {
        if state == .fire {
            let streakFlame = StreakFlame()
            let streakFlameText = UILabel()
            streakFlameText.font = Constants.StreakFlameText.font
            streakFlameText.textColor = Constants.StreakFlameText.color
            streakFlameText.layer.shadowOffset = Constants.StreakFlameText.shadowOffset
            streakFlameText.layer.shadowOpacity = Constants.StreakFlameText.shadowOpacity
            streakFlameText.layer.shadowColor = Constants.StreakFlameText.color.cgColor
            streakFlameText.text = day.rawValue
            streakFlame.addSubview(streakFlameText)
            streakFlameText.pinCenterX(to: streakFlame)
            streakFlameText.pinCenterY(to: streakFlame, 4)
            streakFlame.setWidth(Constants.DayLabel.size.width)
            streakFlame.setHeight(Constants.DayLabel.size.width / StreakFlame.aspectRatio)
            return streakFlame
        } else {
            let dayLabel = UILabel()
            dayLabel.font = Constants.DayLabel.font
            dayLabel.text = day.rawValue
            dayLabel.textAlignment = .center
            dayLabel.setWidth(Constants.DayLabel.size.width)
            dayLabel.setHeight(Constants.DayLabel.size.height)
            dayLabel.layer.borderWidth = Constants.DayLabel.borderWidth
            dayLabel.layer.cornerRadius = Constants.DayLabel.size.width / 2
            dayLabel.layer.masksToBounds = true
            dayLabel.layer.borderColor = state == .active ? Constants.DayLabel.activeBorderColor : Constants.DayLabel.inactiveBorderColor
            dayLabel.textColor = state == .active ? Constants.DayLabel.activeTextColor : Constants.DayLabel.inactiveTextColor
            dayLabel.backgroundColor = state == .active ? Constants.DayLabel.activeBackgroundColor : .clear
            return dayLabel
        }
    }
        
}
