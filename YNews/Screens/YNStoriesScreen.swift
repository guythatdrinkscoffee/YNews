//
//  PostsScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit
import Combine

class YNStoriesScreen: UIViewController {
    // MARK: - Properties
    private let storiesService = YNStoriesService()
    
    private var storiesCancellable: AnyCancellable?
    
    private var stories: [YNItem] = [] {
        didSet {
            storiesTableView.reloadData()
        }
    }
    // MARK: - UI
    private lazy var storiesTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(YNItemCell.self, forCellReuseIdentifier: YNItemCell.resueIdentifer)
        tableView.rowHeight = 100
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
        
        // fetch stories
        fetchPosts(from: .top)
    }
}

// MARK: - Configuration
extension YNStoriesScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Layout
extension YNStoriesScreen {
    private func layoutPostsTableView() {
        view.addSubview(storiesTableView)
        
        storiesTableView.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            storiesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            storiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storiesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: 60),
            activityView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - Methods
extension YNStoriesScreen {
    private func fetchPosts(from type: YNStoryEndpoint) {
        // Cancel the posts cancellable in case the state is in mid fetch
        storiesCancellable?.cancel()
        
        // start the activity view indicator animation
        activityView.start()
        
        // clear the posts
        stories.removeAll()
        
        storiesCancellable = storiesService
            .fetchStories(at: type)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: self.activityView.stop()
                default: break
                }
            }, receiveValue: { stories in
                self.stories = stories
            })
    }
    
}

// MARK: - UITableViewDataSource
extension YNStoriesScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YNItemCell.resueIdentifer, for: indexPath) as? YNItemCell else {
            fatalError("Failed to dequeue cell")
        }
        
        let row = indexPath.row
        let item = stories[row]
        cell.configure(with: item, pos: row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let selectorView = YNStoryTypeSelector(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 80)))
        return selectorView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

// MARK: - UITableViewDelegate
extension YNStoriesScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedStory = stories[indexPath.row]
        let storyDetail = YNStoryDetailScreen(story: selectedStory)
        navigationController?.pushViewController(storyDetail, animated: true)
    }
}
