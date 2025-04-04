//
//  AddWordModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

enum ButtonActions {
    case search
    case save
}

enum AddWordModels {
    enum Initial {
        struct Request {}
        
        struct Response {
            struct Card {
                let viewModel: CardViewModel
            }
            
            let card: Card
        }
        
        struct ViewModel {
            struct View {
                let backgroundColor: UIColor
            }

            struct Card {
                let viewModel: CardViewModel
                let shadowOpacity: Float
                let shadowRadius: CGFloat
                let size: CGSize        
            }

            struct ErrorLabel {
                let text: String
                let font: UIFont
                let textColor: UIColor
                let textAlignment: NSTextAlignment
                let numberOfLines: Int
                let offset: CGFloat
            }

            struct CancelButton {
                let title: String
                let titleColor: UIColor
                let isHidden: Bool
                let offset: CGFloat
            }

            struct MainButton {
                let title: String
                let titleColor: UIColor
                let tintColor: UIColor
                let action: ButtonActions
                let font: UIFont
                let backgroundColor: UIColor
                let cornerRadius: CGFloat
                let isEnabled: Bool
                let size: CGSize
                let offset: CGFloat
            }

            struct StackView {
                let isHidden: Bool
                let size: CGSize
            }
            
            let card: Card
            let view: View
            let errorLabel: ErrorLabel
            let cancelButton: CancelButton
            let mainButton: MainButton
            let stackView: StackView
        }
    }

    enum Loading {
        struct Request {}

        struct Response {
            let isLoading: Bool
        }

        struct ViewModel {
            struct MainButton {
                let isEnabled: Bool
                let title: String
            }

            let isLoading: Bool
            let mainButton: MainButton
        }
    }
    
    enum Search {
        struct Request {
            let word: String
        }
        
        struct Response {
            enum State {
                case loading
                case found
                case failure(error: Error)
            }

            let state: State
            let firstCardViewModel: CardViewModel?
        }
        
        struct ViewModel {
            struct MainButton {
                let title: String
                let isEnabled: Bool
                let action: ButtonActions
            }
            
            struct CancelButton {
                let isHidden: Bool
            }
            
            struct Card {
                let isHidden: Bool
            }

            struct ErrorLabel {
                let isHidden: Bool
                let text: String
            }
            
            let firstCardViewModel: CardViewModel?
            let mainButton: MainButton
            let cancelButton: CancelButton
            let errorLabel: ErrorLabel
            let card: Card
        }
    }
    
    enum TopCardSwipe {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    
    enum ReturnToInitial {
        struct Request {
        }
        struct Response {
            let topCardViewModel: CardViewModel
        }
        
        struct ViewModel {
            struct Card {
                let isHidden: Bool
                let viewModel: CardViewModel
            }
            
            struct MainButton {
                let title: String
                let action: ButtonActions
            }
            
            struct CancelButton {
                let isHidden: Bool
            }
            
            let card: Card
            let mainButton: MainButton
            let cancelButton: CancelButton
        }
    }

    enum SaveWord {
        struct Request {
            let word: WordModel
        }
    }
    
    enum ToggleDisplayMode {
        struct Request {}
        struct Response {
            let mode: CardFaceType
        }
        
        struct ViewModel {
            let image: UIImage
        }
    }
}
