//
//  SyntaxHighlightViewController.swift
//  Mark Viewer
//
//  Created by Nelson on 2019/5/19.
//  Copyright © 2019 Nelson Tai. All rights reserved.
//

import UIKit

final class SyntaxHighlightViewController: UIViewController {
    private let markdownView = MarkdownView(frame: .zero)
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Style")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private lazy var styles: [String] = {
        let styles = MarkdownView.SyntaxHighlight.allCases.map { $0.rawValue }.sorted()
        return styles
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(markdownView)

        title = "Syntax Highlight Setting"
        markdownView.loadCodeSample()

        setupConstraints()
    }
}

// MARK: - UITableViewDataSource
extension SyntaxHighlightViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = styles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Style", for: indexPath)
        cell.textLabel?.text = style
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SyntaxHighlightViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let style = styles[indexPath.row]
        markdownView.change(syntaxHighlight: MarkdownView.SyntaxHighlight(rawValue: style)!)
    }
}

private extension SyntaxHighlightViewController {
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 140)
        ])

        markdownView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markdownView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            markdownView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            markdownView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            markdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
