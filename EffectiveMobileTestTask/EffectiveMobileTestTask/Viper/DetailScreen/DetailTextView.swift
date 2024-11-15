//
//  DetailTextView.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 15.11.2024.
//

import UIKit
import SnapKit

final class DetailTextView: UITextView {

    // MARK: - Instance Properties

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize

        if size.height == UIView.noIntrinsicMetric {
            layoutManager.ensureLayout(for: textContainer)
            let heightInset = textContainerInset.top + textContainerInset.bottom
            size.height = layoutManager.usedRect(for: textContainer).height + heightInset
        }

        return size
    }

    // MARK: - Init

    override init(
        frame: CGRect,
        textContainer: NSTextContainer?
    ) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    private func setupView() {
        font = .systemFont(ofSize: 16)
        backgroundColor = .clear
        isScrollEnabled = false
        textContainer.lineFragmentPadding = 0
        textColor = .white
        delegate = self
    }
}

// MARK: - UITextViewDelegate

extension DetailTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Configure

extension DetailTextView {
    func configure(text: String) {
        self.text = text
        invalidateIntrinsicContentSize()
    }
}
