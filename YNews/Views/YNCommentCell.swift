//
//  YNCommentCell.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/11/23.
//

import UIKit

class YNCommentCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "YNCommentCell"
    
    // MARK: - UI
    private lazy var userLabel : UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemBlue
        return label
    }()
    
    private lazy var topStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [userLabel])
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var textView : UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = .preferredFont(forTextStyle: .body)
        return tv
    }()

    private lazy var rootStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [topStackView, textView])
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutRootStackView()
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

}

// MARK: - Configuration
extension YNCommentCell {
    public func set(_ item: YNItem) {
        userLabel.text = item.author
        textView.text = item.text?.htmlToString()
    }
}

// MARK: - Layout
extension YNCommentCell {
    private func layoutRootStackView() {
        contentView.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: 1),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalToSystemSpacingBelow: rootStackView.bottomAnchor, multiplier: 1)
        ])
    }
}
