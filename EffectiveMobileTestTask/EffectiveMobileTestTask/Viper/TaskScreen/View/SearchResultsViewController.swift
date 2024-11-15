//
//  SearchResultsViewController.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func changeTaskStatusFromSearchResultsVC(_ task: Task)
    func shareTaskFromSearchResultsVC(_ task: Task)
    func editTaskFromSearchResultsVC(_ task: Task)
    func deleteTaskFromSearchResultsVC(_ task: Task)
}

final class SearchResultsViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: SearchResultsViewControllerDelegate?
    private var filteredTasks: [Task] = [] {
        didSet {
            applySnapshot()
        }
    }

    private enum Section {
        case main
    }

    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: UITableViewDiffableDataSource<Section, UUID>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
        setupDataSource()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, UUID>(
            tableView: tableView
        ) { [ weak self ] tableView, indexPath, _  in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as! TaskTableViewCell
            let task = filteredTasks[indexPath.row]
            cell.configure(with: task)
            cell.delegate = self
            return cell
        }
    }

    // MARK: - Public Methods
    func updateResults(with tasks: [Task]) {
        self.filteredTasks = tasks
    }

    // MARK: - Private Methods
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredTasks.map { $0.uuid })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.editTaskFromSearchResultsVC(filteredTasks[indexPath.row])
    }
}

extension SearchResultsViewController: TaskTableViewCellDelegate {
    func changeTaskStatus(_ task: Task?) {
        guard let task = task else { return }
        delegate?.changeTaskStatusFromSearchResultsVC(task)
        if let index = filteredTasks.firstIndex(where: { $0.uuid == task.uuid }) {
            filteredTasks[index] = task
        } else {
            filteredTasks.append(task)
        }
    }

    func deleteTask(_ task: Task) {
        delegate?.deleteTaskFromSearchResultsVC(task)
        filteredTasks.removeAll(where: { $0.uuid == task.uuid })
    }

    func shareTask(_ task: Task) {
        delegate?.shareTaskFromSearchResultsVC(task)
    }

    func editTask(_ task: Task) {
        delegate?.editTaskFromSearchResultsVC(task)
    }
}
