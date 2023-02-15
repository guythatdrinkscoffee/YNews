//
//  YNSelectionDelegate.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/14/23.
//

import UIKit

protocol YNSelectionDelegate: UIViewController {
    func controller(didSelect item: YNItem)
}
