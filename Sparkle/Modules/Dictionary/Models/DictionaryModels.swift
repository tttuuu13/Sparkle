//
//  DictionaryModels.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

enum DictionaryModels {
    enum LoadWords {
        struct Request {}

        struct Response {
        }

        struct ViewModel {
        }
    }

    enum DeleteWord {
        struct Request {
            let indexPath: IndexPath
        }
        
        struct Response {
            let indexPath: IndexPath
        }
        
        struct ViewModel {
            let indexPath: IndexPath
        }
    }
    
    enum SortWords {
        enum SortType {
            case newer
            case older
            case alphabet
            case goodLevel
            case badLevel
        }
        
        struct Request {
            let sortType: SortType
        }
        
        struct Response {}
        struct ViewModel{}
    }
}


