//
//  PracticeModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

enum PracticeModel {
    enum LoadCards {
        struct Request {}

        struct Response {
            let progress: Float
        }

        struct ViewModel {
            let progress: Float
        }
    }
    
    enum LoadSmartShuffle {
        struct Request {
            let words: [WordModel]
            let amount: Int
        }
        
        struct Response {
            enum State {
                case loading
                case enabled
                case disabled
                case failure(error: Error)
            }

            let state: State
        }
        
        struct ViewModel {
            let icon: UIImage?
            let iconTintColor: UIColor?
            let needsUpdate: Bool
        }
    }

    enum HandleTopCardSwipe {
        struct Request {
            let direction: CardStackView.SwipeDirection
        }

        struct Response {
            let progress: Float 
        }

        struct ViewModel {
            let progress: Float
        }
    }
    
    enum DeleteTopWord {
        struct Request {}
        
        struct Response {
            let progress: Float
        }
        
        struct ViewModel {
            let progress: Float
        }
    }
}
