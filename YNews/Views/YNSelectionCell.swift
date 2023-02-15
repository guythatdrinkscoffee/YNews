//
//  YNSelectionCell.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

class YNSelectionCell: UITableViewCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: YNSelectionCell.self)
    
    private var selection: YNSelection! = .none {
        didSet {
            configure(with: selection)
        }
    }
    
    // MARK: -  UI
    private var iconView: UIView!
    private var titleLabel: UILabel!
    
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
        
        if let titleLabel = titleLabel {
            if selected {
                titleLabel.textColor = .white
            } else {
                titleLabel.textColor = .label 
            }
        }
    }
}

// MARK: - Private Configuration
extension YNSelectionCell {
    private func configure(with selection: YNSelection) {
        configureIconView(for: selection)
        configureTitleLabel(for: selection)
    }
    
    private func configureIconView(for selection: YNSelection) {
        iconView = selection.makeIconView()
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 2)
        ])
    }
    
    private func configureTitleLabel(for selection: YNSelection) {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.text = selection.name
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: iconView.trailingAnchor, multiplier: 2),
        ])
    }
}
// MARK: - Public Configuration
extension YNSelectionCell {
    public func set(_ selection: YNSelection?) {
        guard let selection = selection else { return }
        self.selection = selection
    } 
}
