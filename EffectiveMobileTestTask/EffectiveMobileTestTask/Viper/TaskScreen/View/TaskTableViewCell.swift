//
//  TaskTableViewCell.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import UIKit
import SnapKit

protocol TaskTableViewCellDelegate: AnyObject {
    func deleteTask(_ task: Task)
    func shareTask(_ task: Task)
    func editTask(_ task: Task)
    func changeTaskStatus(_ task: Task)
}

final class TaskTableViewCell: BaseTableViewCell {

    weak var delegate: TaskTableViewCellDelegate?

    private var labelsStackviewLeadingConstraint: Constraint?
    private var labelsStackviewTrailingConstraint: Constraint?
    private var task: Task?

    private lazy var statusIconView = make(UIImageView()) { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.image = UIImage(systemName: "circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
    }

    private lazy var titleLabel = make(UILabel()) { label in
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var descriptionLabel = make(UILabel()) { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var dateLabel = make(UILabel()) { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: "textFieldBackround")
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var labelsStackview = make(UIStackView()) { stackview in
        stackview.axis = .vertical
        stackview.alignment = .leading
        stackview.spacing = 6
        stackview.translatesAutoresizingMaskIntoConstraints = false
        [ titleLabel, descriptionLabel, dateLabel ]
            .forEach(stackview.addArrangedSubview(_:))
    }

    private lazy var separatorView = make(UIView()) { view in
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupContraints()
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }


    private func setupView() {
        contentView.backgroundColor = .black
        selectionStyle = .none
        contentView.addSubview(statusIconView)
        contentView.addSubview(labelsStackview)
        contentView.addSubview(separatorView)
    }

    private func setupContraints() {
        statusIconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(12)
            make.width.equalTo(26)
            make.height.equalTo(26)
        }

        labelsStackview.snp.makeConstraints { make in
            labelsStackviewLeadingConstraint = make.leading.equalToSuperview().inset(52).constraint
            labelsStackviewTrailingConstraint = make.trailing.equalToSuperview().inset(20).constraint
            make.verticalEdges.equalToSuperview().inset(12)
        }

        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func configure(with task: Task) {
        self.task = task
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        dateLabel.text = task.date
        statusIconView.image = UIImage(systemName: task.isCompleted ? "checkmark.circle" : "circle")
        statusIconView.tintColor = task.isCompleted ? .yellow : .gray

        titleLabel.textColor = task.isCompleted ? .systemGray : .white
        descriptionLabel.textColor = task.isCompleted ? .systemGray : .white
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task.title)
        if task.isCompleted {
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        }
        titleLabel.attributedText = attributeString
    }
}


extension TaskTableViewCell: UIContextMenuInteractionDelegate {

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        highlight()
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addAnimations {
            self.unhighlight()
        }
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            guard let task = self.task else { return UIMenu()}
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.delegate?.editTask(task)
            }

            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "export")) { _ in
                self.delegate?.shareTask(task)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { _ in
                self.delegate?.deleteTask(task)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }

    private func highlight() {
        contentView.backgroundColor = .textFieldBackround
        statusIconView.isHidden = true
        separatorView.isHidden = true
        labelsStackviewLeadingConstraint?.update(inset: 16)
        labelsStackviewTrailingConstraint?.update(inset: 16)
    }

    private func unhighlight() {
        contentView.backgroundColor = .black
        statusIconView.isHidden = false
        separatorView.isHidden = false
        labelsStackviewLeadingConstraint?.update(inset: 52)
        labelsStackviewTrailingConstraint?.update(inset: 20)
    }
}
extension TaskTableViewCell {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
