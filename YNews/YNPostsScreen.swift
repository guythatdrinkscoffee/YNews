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
        tableView.delegate = self
        tableView.register(YNItemCell.self, forCellReuseIdentifier: YNItemCell.resueIdentifer)
        tableView.rowHeight = 95
        return tableView
    }()
    
    private lazy var titleViewButton : UIButton = {
        var config = UIButton.Configuration.borderless()
        config.title = "New"
        config.image = UIImage(systemName: "chevron.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        config.imagePadding = 5
        config.imagePlacement = .trailing
        
        let button = UIButton(configuration: config)
        button.showsMenuAsPrimaryAction = true
        button.menu = configureTitleViewMenu()
        return button
    }()
    
    private let activityView = YNActivityIndicatorView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
        configureNavigationBar()
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
    
    private func configureNavigationBar() {
        navigationItem.titleView = titleViewButton
    }
    
    private func configureTitleViewMenu() -> UIMenu {
        let newStories = UIAction(title: "New", image: UIImage(systemName: "wand.and.stars")) { _ in
            
        }
        
        let topStories = UIAction(title: "Top", image: UIImage(systemName: "chart.line.uptrend.xyaxis")) { _ in
            
        }
        
        let bestStories = UIAction(title: "Best", image: UIImage(systemName: "star")) { _ in
            
        }
        
        return UIMenu(children: [newStories, topStories, bestStories])
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

// MARK: - UITableViewDelegate
extension YNPostsScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
