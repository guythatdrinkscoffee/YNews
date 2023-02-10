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
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    // MARK: - Life Cycle
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
        
        layoutTitleLabel()
    }
}

// MARK: - Configuration
extension YNItemCell {
    public func configure(with item: YNItem) {
        titleLabel.text = item.title
    }
}

// MARK: - Layout
extension YNItemCell {
    private func layoutTitleLabel() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
}
