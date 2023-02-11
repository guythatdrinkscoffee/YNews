//
//  YNTableView.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/10/23.
//

import UIKit

class YNTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
          super.init(frame: frame, style: style)
          setContentCompressionResistancePriority(.required, for: .vertical)
      }

      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          setContentCompressionResistancePriority(.required, for: .vertical)
      }

      override var contentSize: CGSize {
          didSet {
              invalidateIntrinsicContentSize()
          }
      }

      override func reloadData() {
          super.reloadData()
          invalidateIntrinsicContentSize()
      }

      override var intrinsicContentSize: CGSize {
          setNeedsLayout()
          layoutIfNeeded()
          return contentSize
      }
}
