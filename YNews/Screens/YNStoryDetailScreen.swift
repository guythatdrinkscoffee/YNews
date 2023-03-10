//
//  YNStoryDetailScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/10/23.
//

import UIKit
import LinkPresentation
import Combine
import SafariServices

class YNStoryDetailScreen: UIViewController {
    // MARK: - Properties
    private var story: YNItem
    private var commentsService: YNCommentsService
    private var linkPreview: LPLinkView!
    private var cancellables = Set<AnyCancellable>()
    private var comments: [YNItem] = []
    
    // MARK: - UI
    private lazy var scrollView : UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var textView : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        return textView
    }()
    
    private lazy var scoreImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        iv.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return iv
    }()
    
    private lazy var scoreLabel : UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var scoreStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scoreImageView, scoreLabel])
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var timeImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        iv.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return iv
    }()
    
    private lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var timeStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timeImageView, timeLabel])
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var commentsImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "text.bubble"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        return iv
    }()
    
    private lazy var commentsLabel : UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGray
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var commentsStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentsImageView, commentsLabel])
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var bottomStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scoreStackView, commentsStackView, timeStackView, UIView()])
        stackView.spacing = 25
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var infoStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, textView, .horizontalSpacer(), bottomStackView, .horizontalSpacer()])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var activityIndicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var commentsTableView : YNTableView = {
        let tableView = YNTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(YNCommentCell.self, forCellReuseIdentifier: YNCommentCell.reuseIdentifier)
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    
    // MARK: - Life cycle
    init(story: YNItem, service: YNCommentsService = YNCommentsService()) {
        self.story = story
        self.commentsService = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuration
        configureViewController()
        
        // layout
        layoutScrollView()
        layoutInfoStackView()
        layoutCommentsTableView()
        
        // set data
        setItemInfo(story: story)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchComments(story: story)
    }
}

// MARK: - Configuration
extension YNStoryDetailScreen {
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - Layout
extension YNStoryDetailScreen {
    private func layoutScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let contentMargins = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentMargins.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentMargins.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentMargins.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentMargins.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func layoutInfoStackView() {
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            infoStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: infoStackView.trailingAnchor, multiplier: 1.5)
        ])
    }
    
    
    private func layoutCommentsTableView() {
        contentView.addSubview(commentsTableView)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            commentsTableView.topAnchor.constraint(equalToSystemSpacingBelow: infoStackView.bottomAnchor, multiplier: 2),
            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: commentsTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: commentsTableView.centerYAnchor)
        ])
    }
}

// MARK: - Methods
extension YNStoryDetailScreen {
    private func setItemInfo(story: YNItem) {
        titleLabel.text = story.title
        scoreLabel.text = story.score?.formatted() ?? "0"
        commentsLabel.text = story.kids?.count.formatted() ?? "0"
        timeLabel.text = story.relativeTime
        
        let middle = (infoStackView.arrangedSubviews.count / 2) - 1
        
        if let preview = linkPreview, let link = story.link {
            textView.isHidden = true
            fetchMetadata(for: preview, with: link)
        } else if let link = story.link {
            linkPreview = LPLinkView(url: link)
            infoStackView.insertArrangedSubview(linkPreview, at: middle)
            infoStackView.spacing = 20
            textView.isHidden = true

            fetchMetadata(for: linkPreview, with: link)
        } else if let text = story.getAttributedText() {
            linkPreview.isHidden = true
            textView.attributedText = text
            infoStackView.spacing = 10
        }
    }
    
    private func fetchComments(story: YNItem) {
        guard let comments = story.kids else { return }
        
        activityIndicator.startAnimating()
        
        commentsService.fetchRootComments(ids: comments)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { comments in
                self.comments = comments
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.activityIndicator.isAnimating {
                        self.activityIndicator.stopAnimating()
                    }
                    
                    self.commentsTableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    public func setItem(item: YNItem) {
        linkPreview.isHidden = false
        textView.isHidden = false
        comments.removeAll()
        commentsTableView.reloadData()
        setItemInfo(story: item)
        fetchComments(story: item)
    }
    
    private func fetchMetadata(for preview: LPLinkView, with url: URL) {
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: url) { md, err in
            guard let md = md, err == nil else { return }
            
            DispatchQueue.main.async {
                preview.metadata = md
                preview.sizeToFit()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension YNStoryDetailScreen: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YNCommentCell.reuseIdentifier, for: indexPath) as? YNCommentCell else {
            fatalError("Failed to dequeue a reusable cell")
        }
        
        let comment = comments[indexPath.row]
        cell.set(comment, delegate: self)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension YNStoryDetailScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - UITextViewDelegate
extension YNStoryDetailScreen: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(URL) {
            let safariVC = SFSafariViewController(url: URL)
            safariVC.modalPresentationStyle = .overFullScreen
            present(safariVC, animated: true)
            return false
        } else {
            return false
        }
    }
}
// MARK: - Preview
#if canImport(SwiftUI)
import SwiftUI

struct YNStoryDetailScreen_Preview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            let detail = YNStoryDetailScreen(story: YNItem.placeholder)
            return detail
        }
    }
}

#endif

extension UIView {
    static public func horizontalSpacer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .systemGray5
        return view
    }
}
