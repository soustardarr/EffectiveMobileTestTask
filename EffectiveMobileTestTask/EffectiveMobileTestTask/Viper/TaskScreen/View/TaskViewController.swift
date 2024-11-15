//
//  TaskViewController.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 14.11.2024.
//

import UIKit

protocol TaskViewInput: AnyObject {
    var output: TaskViewOutput? { get set }
    func displayTasks(_ tasks: [Task])
}

protocol TaskViewOutput: AnyObject {
    func openDetailScreen(with task: Task)
    func openDetailScreen()
    func deleteTask(with task: Task)
    func shareTask(with task: Task)
    func viewDidLoad()
}

final class TaskViewController: UIViewController, TaskViewInput {

    //MARK: - stored prop
    var output: TaskViewOutput?

    private enum Section {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, Int>?
    private var entities: [Task] = [
        Task(id: 1, title: "Задача 1", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: true),
        Task(id: 2, title: "Задача 1", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: false),
        Task(id: 3, title: "Задача 1", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: true),
        Task(id: 4, title: "Задача 1", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: false)
    ] {
        didSet {
            countTaskLabel.text = "\(entities.count) Задач"
        }
    }

    private var searchController = UISearchController()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)

    private lazy var bottomBarView = make(UIView()) { view in
        view.backgroundColor = .textFieldBackround
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var createTaskButton = make(UIButton()) { button in
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .yellow
        button.addAction(
            UIAction {
                [ weak self ] _ in self?.output?.openDetailScreen()
            },
            for: .touchUpInside
        )
    }

    private lazy var countTaskLabel = make(UILabel()) { label in
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        label.text = "\(self.entities.count) Задач"
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        setupView()
        setupConstrainsts()
        setupDataSource()
        updateSnapshot()
        output?.viewDidLoad()
    }

    //MARK: - methods
    func displayTasks(_ tasks: [Task]) {
        entities = tasks
        updateSnapshot()
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(tableView)
        bottomBarView.addSubview(countTaskLabel)
        bottomBarView.addSubview(createTaskButton)
        view.addSubview(bottomBarView)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(
            TaskTableViewCell.self,
            forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier
        )
    }

    private func setupNavBar() {
        navigationItem.title = "Задачи"
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonTitle = "Назад"
        setupSearchTextField()
    }

    private func setupConstrainsts() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }

        bottomBarView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview().inset(-1)
            make.height.equalTo(83)
        }

        countTaskLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20.5)
        }

        createTaskButton.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(14)
        }
    }

    private func setupSearchTextField() {
        let searchTextField = searchController.searchBar.searchTextField
        searchTextField.textColor = .white
        searchTextField.backgroundColor = .textFieldBackround
        searchTextField.leftView?.tintColor = .systemGray
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.systemFont(ofSize: 17)
            ]
        )
        searchTextField.clearButtonMode = .never
        searchController.searchBar.delegate = self
    }


    // MARK: - Actions
    @objc private func microphoneButtonTapped() {
        print("Микрофон нажат")
    }
}

// MARK: - searchbar delegate
extension TaskViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Кнопка отмены нажата")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Текст изменился на: \(searchText)")
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("Изменен выбранный сегмент на: \(selectedScope)")
    }
}

// MARK: - table delegate
extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.openDetailScreen(with: entities[indexPath.row])
    }
}

// MARK: - data source
extension TaskViewController {
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView) { (tableView, indexPath, id) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
            guard let task = self.entities.first(where: { $0.id == id }) else { return nil }
            cell.configure(with: task)
            cell.delegate = self
            return cell
        }
    }
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(entities.map { $0.id })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - cell delegate
extension TaskViewController: TaskTableViewCellDelegate {
    func deleteTask(_ task: Task) {
        output?.deleteTask(with: task)
    }
    
    func shareTask(_ task: Task) {
        output?.shareTask(with: task)
    }
    
    func editTask(_ task: Task) {
        output?.openDetailScreen(with: task)
    }
}
