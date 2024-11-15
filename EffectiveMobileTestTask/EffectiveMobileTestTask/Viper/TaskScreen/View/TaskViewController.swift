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
    func addTask(_ task: Task)
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
    private var dataSource: UITableViewDiffableDataSource<Section, UUID>?
    private var entities: [Task] = [
        Task(id: 1, title: "Задача", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: true),
        Task(id: 2, title: "ааааа", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: false),
        Task(id: 3, title: "бббб", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: true),
        Task(id: 4, title: "ссссс", description: "Погулять с собакой и сходить в зал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыбазал рыбы рыба рыба рыба", date: "02/20/20", isCompleted: false)
    ] {
        didSet {
            countTaskLabel.text = "\(entities.count) Задач"
            updateSnapshot()
        }
    }

    private var searchController: UISearchController!
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
        let searchResultsController = SearchResultsViewController()
        searchResultsController.delegate = self
        searchController = UISearchController(searchResultsController: searchResultsController)
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

    func addTask(_ task: Task) {
        if let index = entities.firstIndex(where: { $0.id == task.id }) {
            entities[index] = task
        } else {
            entities.insert(task, at: 0)
        }
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
        tableView.backgroundColor = .black
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
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(bottomBarView.snp.top)
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
}

// MARK: - searchbar delegate
extension TaskViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSnapshot()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredEntities = entities.filter { task in
            task.title.lowercased().contains(searchText.lowercased())
        }

        let searchResultsVC = searchController.searchResultsController as? SearchResultsViewController
        searchResultsVC?.updateResults(with: filteredEntities)
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
        dataSource = UITableViewDiffableDataSource<Section, UUID>(tableView: tableView) { [ weak self ] tableView, indexPath, _ in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
            let task = self.entities[indexPath.row]
            cell.configure(with: task)
            cell.delegate = self
            return cell
        }
    }
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(entities.map { $0.uuid })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


// MARK: - cell delegate
extension TaskViewController: TaskTableViewCellDelegate {
    func changeTaskStatus(_ task: Task?) {
        guard let task = task else { return }
        if let index = entities.firstIndex(where: { $0.id == task.id }) {
            entities[index] = task
        } else {
            entities.append(task)
        }
    }
    
    func deleteTask(_ task: Task) {
        output?.deleteTask(with: task)
        entities.removeAll(where: { $0.id == task.id })
    }
    
    func shareTask(_ task: Task) {
        output?.shareTask(with: task)
    }
    
    func editTask(_ task: Task) {
        output?.openDetailScreen(with: task)
    }
}

extension TaskViewController: SearchResultsViewControllerDelegate {
    func changeTaskStatusFromSearchResultsVC(_ task: Task) {
        if let index = entities.firstIndex(where: { $0.uuid == task.uuid }) {
            entities.remove(at: index)
            entities.insert(task, at: index)
        } else {
            entities.append(task)
        }
    }
    
    func shareTaskFromSearchResultsVC(_ task: Task) {
        output?.shareTask(with: task)
    }
    
    func editTaskFromSearchResultsVC(_ task: Task) {
        output?.openDetailScreen(with: task)
    }
    
    func deleteTaskFromSearchResultsVC(_ task: Task) {
        output?.deleteTask(with: task)
        entities.removeAll(where: { $0.uuid == task.uuid })
    }
}
