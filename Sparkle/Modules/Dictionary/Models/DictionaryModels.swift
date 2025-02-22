//
//  DictionaryModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

enum DictionaryModels {
    enum FetchWords {
        struct Request {}

        struct Response {
            let words: [WordModel]
        }

        struct ViewModel {
            let words: [WordModel]
        }
    }

    enum DeleteWord {
        struct Request {
            let word: WordModel
        }
    }
}


