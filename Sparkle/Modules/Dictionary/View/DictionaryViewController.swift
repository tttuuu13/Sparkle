//
//  DictionaryViewController.swift
//  Sparkle
//
//  Created by тимур on 22.02.2025.
//

import UIKit

protocol DictionaryDisplayLogic: AnyObject {
    func displayWords(_ viewModel: DictionaryModels.LoadWords.ViewModel)
    func displayDeleteWord(_ viewModel: DictionaryModels.DeleteWord.ViewModel)
    func displayError(_ error: Error)
}

class DictionaryViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        enum View {
            static let bgColor: UIColor = .white
        }
    }
    
    // MARK: - Properties
    var interactor: (DictionaryBusinessLogic & UITableViewDataSource)?

    // MARK: - UI Elements
    private let tableView: UITableView = UITableView()
    private var menu: UIMenu = UIMenu()
    private let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "arrow.up.arrow.down"), primaryAction: nil, menu: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = UIMenu(children: [
            UIAction(title: "Сначала новые", handler: { _ in self.sort(by: .newer)}),
            UIAction(title: "Сначала старые", handler: { _ in self.sort(by: .older)}),
            UIAction(title: "По алфавиту", handler: { _ in self.sort(by: .alphabet)}),
            UIAction(title: "Сначала хороший уровень", handler: { _ in self.sort(by: .goodLevel)}),
            UIAction(title: "Сначала слабый уровень", handler: { _ in self.sort(by: .badLevel)})
        ])
        
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        interactor?.loadWords(DictionaryModels.LoadWords.Request())
    }

    // MARK: - UI Configuration
    private func configureUI() {
        navigationItem.title = "Словарь"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        menuButton.menu = menu
        navigationItem.rightBarButtonItem = menuButton
        view.backgroundColor = Constants.View.bgColor

        configureTableView()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = interactor
        tableView.register(DictionaryTableViewCell.self, forCellReuseIdentifier: "dictionaryCell")
        tableView.backgroundColor = Constants.View.bgColor

        view.addSubview(tableView)
        tableView.pinHorizontal(to: view)
        tableView.pinVertical(to: view)
    }
    
    private func sort(by sortType: DictionaryModels.SortWords.SortType) {
        interactor?.sortWords(.init(sortType: sortType))
    }
}

extension DictionaryViewController: DictionaryDisplayLogic {
    func displayWords(_ viewModel: DictionaryModels.LoadWords.ViewModel) {
        tableView.reloadData()
    }
    
    func displayDeleteWord(_ viewModel: DictionaryModels.DeleteWord.ViewModel) {
        tableView.deleteRows(at: [viewModel.indexPath], with: .fade)
    }

    func displayError(_ error: Error) {
    }
}

extension DictionaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            self.interactor?.deleteWord(DictionaryModels.DeleteWord.Request(indexPath: indexPath))
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
}

@available(iOS 17.0, *)
#Preview {
    DictionaryBuilder.build()
}
