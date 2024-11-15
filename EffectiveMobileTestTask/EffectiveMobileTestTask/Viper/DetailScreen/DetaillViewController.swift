//
//  DetaillViewController.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import UIKit

final class DetaillViewController: UIViewController {

    var task: Task?

    private lazy var textView = DetailTextView()

    private lazy var dateLabel = make(UILabel()) { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    init(task: Task? = nil) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = task?.title
        self.dateLabel.text = task?.date
        textView.configure(text: task?.description ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        textView.becomeFirstResponder()
    }

    private func setupView() {
        view.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel)
        view.addSubview(textView)

        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
        }

        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
    }
}
