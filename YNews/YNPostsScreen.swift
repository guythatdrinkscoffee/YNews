//
//  PostsScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit
import Combine

class YNPostsScreen: UIViewController {
    // MARK: - Properties
    private let postsService = YNPostsService()
    
    private var postsCancellable: AnyCancellable?
    
    private var posts: [YNItem] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    
    // MARK: - UI
    private lazy var postsTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(YNItemCell.self, forCellReuseIdentifier: YNItemCell.resueIdentifer)
        tableView.rowHeight = 95
        return tableView
    }()
    
    private let activityView = YNActivityIndicatorView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
        
        // layout
        layoutPostsTableView()
        
        // loading state
        activityView.start()
        
        
        postsCancellable = postsService
            .newStories()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in
                self.activityView.stop()
            }, receiveValue: { posts in
                self.posts = posts
            })
    }
}

// MARK: - Configuration
extension YNPostsScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Layout
extension YNPostsScreen {
    private func layoutPostsTableView() {
        view.addSubview(postsTableView)
        
        postsTableView.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: 60),
            activityView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITableViewDataSource
extension YNPostsScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YNItemCell.resueIdentifer, for: indexPath) as? YNItemCell else {
            fatalError("Failed to dequeue cell")
        }
        
        let row = indexPath.row
        let item = posts[row]
        cell.configure(with: item, pos: row)
        return cell
    }
}
