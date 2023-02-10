//
//  YNItemCell.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class YNItemCell: UITableViewCell {
    // MARK: - Properties
    static let resueIdentifer = String(describing: YNItemCell.self)
    
    // MARK: - UI
    private lazy var indexLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .black)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var hostLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private lazy var userLabel : UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var scoreImageView : UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemBlue
        iv.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return iv
    }()
    
    private lazy var scoreLabel : UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
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
        iv.tintColor = .systemOrange
        return iv
    }()
    
    private lazy var commentsLabel : UILabel = {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemOrange
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var commentsStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [commentsImageView, commentsLabel])
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var userInfoStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [hostLabel, userLabel])
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var bottomStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [scoreStackView, commentsStackView, timeStackView, UIView()])
        stackView.spacing = 25
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var topStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, userInfoStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private lazy var rootStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIndexLabel()
        layoutRootStackView()
    }
}

// MARK: - Configuration
extension YNItemCell {
    public func configure(with item: YNItem, pos: Int) {
        indexLabel.text = "\(pos + 1)."
        titleLabel.text = item.title
        hostLabel.text = item.host
        userLabel.text = item.author
        scoreLabel.text = item.score?.formatted() ?? "0"
        commentsLabel.text = item.kids?.count.formatted() ?? "0"
        timeLabel.text = item.relativeTime
    }
}

// MARK: - Layout
extension YNItemCell {
    private func layoutIndexLabel() {
        contentView.addSubview(indexLabel)
        
        NSLayoutConstraint.activate([
            indexLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            indexLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),
            indexLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
 
    private func layoutRootStackView() {
        contentView.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: indexLabel.trailingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 2),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: rootStackView.bottomAnchor, multiplier: 1),
        ])
    }
}
