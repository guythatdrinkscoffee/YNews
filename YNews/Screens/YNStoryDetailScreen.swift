//
//  YNStoryDetailScreen.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/10/23.
//

import UIKit
import LinkPresentation
import WebKit


class YNStoryDetailScreen: UIViewController {
    // MARK: - Properties
    private var story: YNItem
    private var linkPreview: LPLinkView!
    
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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textView : UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
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
        let sv = UIStackView(arrangedSubviews: [titleLabel, bottomStackView])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Life cycle
    init(story: YNItem) {
        self.story = story
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
        
        
        // set data
        setItemInfo()
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
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
    
    private func layoutInfoStackView() {
        contentView.addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            infoStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1.5),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: infoStackView.trailingAnchor, multiplier: 1.5),
            
        ])
    }
}

// MARK: - Methods
extension YNStoryDetailScreen {
    private func setItemInfo() {
        titleLabel.text = story.title
        scoreLabel.text = story.score?.formatted() ?? "0"
        commentsLabel.text = story.kids?.count.formatted() ?? "0"
        timeLabel.text = story.relativeTime
        
        let middle = infoStackView.arrangedSubviews.count / 2

        if let link = story.link {
            linkPreview = LPLinkView(url: link)
            infoStackView.insertArrangedSubview(linkPreview, at: middle)
            infoStackView.spacing = 20
        } else if let text = story.text {
            textView.text = text.htmlToString()
            infoStackView.insertArrangedSubview(textView, at: middle)
            infoStackView.spacing = 10
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



extension String {
    func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: nil).string
    }
}

