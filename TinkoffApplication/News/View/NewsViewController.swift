//
//  NewsViewController.swift
//  TinkoffApplication
//
//  Created by Дмитрий Пермяков on 22.07.2023.
//  Copyright © 2021 Wildberries LLC. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {

    // MARK: Dependencies

    private let presenter: NewsPresenterInput

    // MARK: Subviews

    private let tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.estimatedRowHeight = 200
        table.rowHeight = UITableView.automaticDimension
        table.register(NewsCell.self, forCellReuseIdentifier: NewsCell.cellID)
        return table
    }()
    
    // MARK: Properties

    private var viewModel = NewsViewModel()

    // MARK: Init

    init(presenter: NewsPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter.viewDidFinishLaunching()
    }
    
}

// MARK: - Setup
private extension NewsViewController {
    func setup() {
        self.title = "Новости"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: - NewsViewControllerInput

extension NewsViewController: NewsViewControllerInput {

    func configure(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }

}

// MARK: - UITableViewDataSource

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(20, viewModel.newsCell.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellID, for: indexPath) as? NewsCell else { return UITableViewCell() }
        cell.configure(with: viewModel.newsCell[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellID = viewModel.newsCell[indexPath.row].id
        presenter.userDidSelectNews(cellID: cellID)
    }
}

// MARK: - Preview:

import SwiftUI
struct PreviewNewsViewController: PreviewProvider {
    /// Менять для других привью.
    typealias CurrentPreview = PreviewNewsViewController.ContainerView
    
    static var previews: some View {
        ContainerView()
            .ignoresSafeArea()
//            .preferredColorScheme(.dark)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias PreviewContext = UIViewControllerRepresentableContext<CurrentPreview>

        func makeUIViewController(context: PreviewContext) -> some UIViewController {
            return NewsComposer.make()
        }
        
        func updateUIViewController(
            _ uiViewController: CurrentPreview.UIViewControllerType,
            context: PreviewContext) {
        }
    }
}
