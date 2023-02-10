//
//  YNActivityIndicatorView.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/9/23.
//

import UIKit

class YNActivityIndicatorView: UIView {
    // MARK: - UI
    private lazy var indicatorView : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        
        return view
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutIndicatorView()
    }
    
    // MARK: - Layout
    private func layoutIndicatorView() {
        self.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    // MARK: - Methods
    public func start() {
        indicatorView.startAnimating()
        isHidden = false
    }
    
    public func stop() {
        indicatorView.stopAnimating()
        isHidden = true
    }
}
