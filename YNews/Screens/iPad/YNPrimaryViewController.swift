//
//  YNPrimaryViewController.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

class YNPrimaryViewController: UITableViewController {
    // MARK: - Properties
    private var sections: [YNSelectionSection] = []
    
    // MARK: - Init
    init(sections: [YNSelectionSection], style: UITableView.Style) {
        self.sections = sections
        super.init(style: style)
        configureReusableCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configuration
        configureNavigationBar()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].children.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YNSelectionCell.reuseIdentifier, for: indexPath) as? YNSelectionCell else {
            fatalError("failed to dequeue a reusable cell")
        }
        
        let selection = sections[indexPath.section].children[indexPath.row]
        cell.set(selection)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let selection = sections[indexPath.section].children[indexPath.row]
        return selection.withRowHeight()
    }
}


// MARK: - Configuration
extension YNPrimaryViewController {
    private func configureReusableCells() {
        tableView.register(YNSelectionCell.self, forCellReuseIdentifier: YNSelectionCell.reuseIdentifier)
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
