//
//  DetaillViewController.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import UIKit

protocol DetailViewInput: AnyObject {
    var output: DetailViewOutput? { get set }
}
protocol DetailViewOutput: AnyObject {
    func saveTask(_ task: Task)
    func updateTask(_ task: Task, uuid: UUID)
    func popViewController(with task: Task, oldUUID: UUID)
    func presentAlert(with title: String, message: String)
}

final class DetailViewController: UIViewController, DetailViewInput {
    
    var output: DetailViewOutput?

    private var task: Task?

    private lazy var titleTextField = make(UITextField()) { textField in
        textField.placeholder = "Введи название"
        textField.font = .systemFont(ofSize: 34, weight: .bold)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .white
    }
    private lazy var textView = DetailTextView()

    private lazy var dateLabel = make(UILabel()) { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    init(task: Task? = nil) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        titleTextField.text = task?.title
        self.dateLabel.text = task?.date
        textView.configure(text: task?.descriptionText ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDateLabel()
        setupNavigationBar()
        textView.becomeFirstResponder()
    }

    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let rightButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = rightButton
    }

    private func setupDateLabel() {
        guard task == nil else { return }
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: date)
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(titleTextField)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        view.addSubview(textView)

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(41)
        }

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(titleTextField.snp.bottom).offset(8)
        }

        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
    }

    @objc
    private func doneButtonTapped() {
        guard
            let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty,
            let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty
        else {
            output?.presentAlert(with: "ошибка", message: "заполни заголовок и описание")
            return
        }

        let newTask = Task(id: task?.id, uuid: UUID(), title: title, descriptionText: text, date: dateLabel.text!, completed: task?.completed ?? false)

        if let task = self.task {
            output?.updateTask(newTask, uuid: task.uuid)
        } else {
            output?.saveTask(newTask)
        }
        output?.popViewController(with: newTask, oldUUID: task?.uuid ?? newTask.uuid)
    }


}
