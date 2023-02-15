//
//  YNSecondaryViewController.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit
import Combine

class YNSecondaryViewController: UIViewController {
    // MARK: - Properties
    private let storiesService = YNStoriesService()
    
    private var stories: [YNItem] = [] {
        didSet {
            storiesTableView.reloadData()
        }
    }
    
    private var storyCancellable: AnyCancellable?
    private var currentEndpoint: YNStoryEndpoint = .top
    public weak var delegate: YNSelectionDelegate?
    // MARK: - UI
    private lazy var storiesTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(YNItemCell.self, forCellReuseIdentifier: YNItemCell.resueIdentifer)
        tableView.rowHeight = 100
        tableView.backgroundColor = .systemBackground
        tableView.scrollsToTop = true
        return tableView
    }()
    
    private let activityView = YNActivityIndicatorView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // configuration
        configureViewController()
        
        // layout
        layoutStoriesTableView()
        
        // initial fetch
        fetch(endpoint: .top)
        
        //
        setTitle(selection: YNStoryEndpoint.top)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Configuration
extension YNSecondaryViewController {
    private func configureViewController() {
        view.backgroundColor = .systemRed
    }
}

// MARK: - Public Methods
extension YNSecondaryViewController {
    public func fetch(selection: YNSelection?) {
        if let storyEnpoint = selection as? YNStoryEndpoint {
            fetch(endpoint: storyEnpoint)
        }
    }
    
    public func setTitle(selection: YNSelection){
        title = selection.name
    }
}

// MARK: - Methods
extension YNSecondaryViewController {
    private func fetch(endpoint: YNStoryEndpoint) {
        // Cancel the posts cancellable in case the state is in mid fetch
        storyCancellable?.cancel()
        
        //
        currentEndpoint = endpoint
        
        // start the activity view indicator animation
        activityView.start()
        
        storyCancellable = storiesService
            .fetchStories(at: currentEndpoint)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.activityView.stop()
            }, receiveValue: { stories in
                self.stories.append(contentsOf: stories)
            })
    }
}

// MARK: - Layout
extension YNSecondaryViewController {
    private func layoutStoriesTableView() {
        view.addSubview(storiesTableView)
    
        storiesTableView.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            storiesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            storiesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storiesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storiesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityView.heightAnchor.constraint(equalToConstant: 60),
            activityView.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}

// MARK: - UITableViewDataSource
extension YNSecondaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YNItemCell.resueIdentifer, for: indexPath) as? YNItemCell else {
            fatalError("Failed to queue a reusable cell")
        }
        
        let story = stories[indexPath.row]
        cell.configure(with: story, pos: indexPath.row)
        return cell
    }
}

// MARK: - UITaableViewDelegate
extension YNSecondaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedStory = stories[indexPath.row]
        delegate?.controller(didSelect: selectedStory)
    }
}

// MARK: - UIScrollViewDelegate
extension YNSecondaryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (storiesTableView.contentSize.height - 100 - (scrollView.frame.size.height)) {
            if storiesService.isFetching {
                return
            }
            
            fetch(endpoint: currentEndpoint)
        }
    }
}
