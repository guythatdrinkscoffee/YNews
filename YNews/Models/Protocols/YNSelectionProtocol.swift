//
//  YNSelectionProtocol.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

protocol SelectionProtocol: Any {
    var name: String {get}
    var image: UIImage? {get}
    var color: UIColor { get }
    func withRowHeight() -> CGFloat
    func makeIconView() -> UIView
}

extension SelectionProtocol {
    func withRowHeight() -> CGFloat {
        return 55
    }
    
    func makeIconView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        view.backgroundColor = color
        
        let iconImageView = UIImageView(image: image)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        
        view.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 35),
            view.heightAnchor.constraint(equalToConstant: 35),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }
}

