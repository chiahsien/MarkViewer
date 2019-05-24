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
        tableView.rowHeight = 40
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        return tableView
    }()
    private lazy var styles: [String] = {
        let styles = MarkdownView.SyntaxHighlight.allCases.map { $0.rawValue }.sorted()
        return styles
    }()
    private lazy var selectedStyle: String = {
        let style = UserDefaults.standard.string(forKey: SettingKey.syntaxHighlight) ?? MarkdownView.SyntaxHighlight.github.rawValue
        return style
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(markdownView)

        title = "Syntax Highlight Setting"
        markdownView.loadCodeSample()

        setupConstraints()

        if let index = styles.firstIndex(of: selectedStyle) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
                self.markdownView.change(syntaxHighlight: MarkdownView.SyntaxHighlight(rawValue: self.selectedStyle)!)
            }
        }
    }

    func saveSetting() {
        if let style = UserDefaults.standard.string(forKey: SettingKey.syntaxHighlight), style == selectedStyle { return }
        UserDefaults.standard.set(selectedStyle, forKey: SettingKey.syntaxHighlight)
        NotificationCenter.default.post(name: .MarkdownViewSyntaxHighlightSettingDidChange, object: self, userInfo: [SettingKey.syntaxHighlight: selectedStyle])
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
        selectedStyle = styles[indexPath.row]
        markdownView.change(syntaxHighlight: MarkdownView.SyntaxHighlight(rawValue: selectedStyle)!)
    }
}

private extension SyntaxHighlightViewController {
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 160)
        ])

        markdownView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markdownView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            markdownView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            markdownView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            markdownView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
