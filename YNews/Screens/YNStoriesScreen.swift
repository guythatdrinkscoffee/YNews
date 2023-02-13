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
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private let activityView = YNActivityIndicatorView()
    
    private lazy var selectorView : YNStoryTypeSelector = {
        let view = YNStoryTypeSelector(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 50)))
        view.selectionUpdateHandler = { [weak self] selectedType in
            self?.fetchPosts(from: selectedType)
        }
        return view
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
        configureNavigationBar()
        
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
    
    private func configureNavigationBar() {
        let todayLabel = UILabel()
        todayLabel.font = .preferredFont(forTextStyle: .footnote)
        todayLabel.textColor = .systemGray
        todayLabel.text = "Today"
        
        let leftLabel = UILabel()
        leftLabel.font = .preferredFont(forTextStyle: .headline)
        leftLabel.text = Date.now.formatted(.dateTime.weekday(.wide).month().day())
        
        let sv = UIStackView(arrangedSubviews: [todayLabel, leftLabel])
        sv.axis = .vertical
        sv.distribution = .fill
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sv)
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
      
        return selectorView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
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
