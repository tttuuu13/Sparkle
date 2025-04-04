//
//  AddWordConstants.swift
//  Sparkle
//
//  Created by тимур on 04.03.2025.
//

import UIKit

enum AddWordConstants {
    enum View {
        static let backgroundColor: UIColor = UIColor(white: 0.95, alpha: 1)
    }

    enum Card {
        static let shadowOpacity: Float = 0.1
        static let shadowRadius: CGFloat = 40
        static let size: CGSize = CGSize(width: 300, height: 300)
    }

    enum ErrorLabel {
        static let font: UIFont = .systemFont(ofSize: 16)
        static let textColor: UIColor = .red
        static let textAlignment: NSTextAlignment = .center
        static let numberOfLines: Int = 0
        static let offset: CGFloat = 10
    }
    
    enum CancelButton {
        static let title: String = "сбросить"
        static let titleColor: UIColor = .red
        static let isHidden: Bool = true
        static let offset: CGFloat = 10
    }

    enum MainButton {
        static let findTitle: String = "Найти"
        static let loadingTitle: String = "Поиск..."
        static let saveTitle: String = "Запомнить"
        static let titleColor: UIColor = .white
        static let tintColor: UIColor = .systemGreen
        static let isEnabled: Bool = true
        static let font: UIFont = .systemFont(ofSize: 18)
        static let backgroundColor: UIColor = .systemGreen
        static let cornerRadius: CGFloat = 15
        static let offset: CGFloat = 10
        static let size: CGSize = CGSize(width: 180, height: 60)
    }

    enum StackView {
        static let isHidden: Bool = false
        static let size: CGSize = CGSize(width: 300, height: 320)
    }
}
