//
//  AddWordModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import Foundation

enum AddWordModels {
    enum Request {
        struct Search {
            let word: String
            let mode: SearchMode
        }

        struct Add {
            let word: WordModel
        }
    }

    enum Response {
        struct SearchResult {
            let wordModels: [WordModel]
            let mode: SearchMode
        }
    }

    enum ViewModel {
        struct SearchResult {
            let wordModels: [WordModel]
            let mode: SearchMode
        }
    }
}