//
//  AddWordModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

enum AddWordModels {
    enum Search {
        struct Request {
            let word: String
            let mode: DisplayMode
        }
        
        struct Response {
            enum State {
                case loading
                case found
                case failure(error: Error)
            }

            let state: State
            let mode: DisplayMode
        }
        
        struct ViewModel {
            struct MainButton {
                let title: String
                let isEnabled: Bool
            }
            
            struct CancelButton {
                let isHidden: Bool
            }
            
            let mode: DisplayMode
            let firstWordModel: WordModel?
            let errorMessage: String?
        }
    }
}
