//
//  DictionaryViewController.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol DictionaryDisplayLogic: AnyObject {
    func displayWords(_ viewModel: DictionaryModels.FetchWords.ViewModel)
    func displayError(_ error: Error)
}

class DictionaryViewController: UIViewController {
    // MARK: - Properties
    var interactor: DictionaryBusinessLogic?
    private var words: [WordModel] = []

    // MARK: - UI Elements
    private let tableView: UITableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.fetchWords(request: DictionaryModels.FetchWords.Request())
    }

    // MARK: - UI Configuration
    private func configureUI() {
        view.backgroundColor = Constants.View.bgColor

        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Constants.View.bgColor

        view.addSubview(tableView)
        tableView.pinHorizontal(to: view)
        tableView.pinVertical(to: view)
    }

    // MARK: - Constants
    private enum Constants {
        enum View {
            static let bgColor: UIColor = .white
        }
    }
}

extension DictionaryViewController: DictionaryDisplayLogic {
    func displayWords(_ viewModel: DictionaryModels.FetchWords.ViewModel) {
        words = viewModel.words
        tableView.reloadData()
    }

    func displayError(_ error: Error) {
    }
}

extension DictionaryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = words[indexPath.row].word
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let wordToDelete = self.words[indexPath.row]
            self.interactor?.deleteWord(request: DictionaryModels.DeleteWord.Request(word: wordToDelete))
            self.words.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
