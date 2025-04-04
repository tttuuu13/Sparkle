//
//  DictionaryInteractor.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol DictionaryBusinessLogic {
    func loadWords(_ request: DictionaryModels.LoadWords.Request)
    func deleteWord(_ request: DictionaryModels.DeleteWord.Request)
    func sortWords(_ request: DictionaryModels.SortWords.Request)
}

final class DictionaryInteractor: NSObject, DictionaryBusinessLogic {
    var presenter: DictionaryPresentationLogic?
    private var wordModels: [WordModel] = []
    private let wordsStorage = WordsStorage.shared

    func loadWords(_ request: DictionaryModels.LoadWords.Request) {
        do {
            let words = try wordsStorage.getWords()
            wordModels = words
            presenter?.presentWords(DictionaryModels.LoadWords.Response())
        } catch {
            presenter?.presentError(error)
        }
    }

    func deleteWord(_ request: DictionaryModels.DeleteWord.Request) {
        do {
            let wordToDelete = wordModels[request.indexPath.row]
            try wordsStorage.deleteWord(wordToDelete)
            wordModels.remove(at: request.indexPath.row)
            let response = DictionaryModels.DeleteWord.Response(indexPath: request.indexPath)
            presenter?.presentDeleteWord(response)
        } catch {
            presenter?.presentError(error)
        }
    }
    
    func sortWords(_ request: DictionaryModels.SortWords.Request) {
        switch request.sortType {
        case .newer:
            wordModels.sort {
                guard let firstDate = $0.addedDate, let secondDate = $1.addedDate else { return false }
                return firstDate > secondDate
            }
        case .older:
            wordModels.sort {
                guard let firstDate = $0.addedDate, let secondDate = $1.addedDate else { return false }
                return firstDate < secondDate
            }
        case .alphabet:
            wordModels.sort { $0.word < $1.word }
        case .goodLevel:
            wordModels.sort { $0.knowledgeLevel > $1.knowledgeLevel}
        case .badLevel:
            wordModels.sort { $0.knowledgeLevel < $1.knowledgeLevel}
        }
        
        presenter?.presentWords(DictionaryModels.LoadWords.Response())
    }
}

extension DictionaryInteractor: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dictionaryCell", for: indexPath) as? DictionaryTableViewCell else {
            return UITableViewCell()
        }
        
        let wordModel = wordModels[indexPath.row]
        cell.configure(with: wordModel)
        return cell
    }
}
