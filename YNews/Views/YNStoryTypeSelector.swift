//
//  YNStoryTypeSelector.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/12/23.
//

import UIKit

class YNStoryTypeSelector: UIView {
    // MARK: - Public Properties
    public var selectionUpdateHandler: ((YNStoryEndpoint) -> Void)?
    
    // MARK: - Properites
    private  var selectedType: YNStoryEndpoint = .top {
        didSet {
            selectionUpdateHandler?(selectedType)
        }
    }
    private  var buttons: [UIButton] = []
    // MARK: - UI
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rootStackView : UIStackView = {
        let stacView = UIStackView(arrangedSubviews: [])
        stacView.translatesAutoresizingMaskIntoConstraints = false
        stacView.distribution = .equalSpacing
        return stacView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layoutScrollView()
        layoutRootStackView()
        
        configureButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configuration
extension YNStoryTypeSelector {
    private func configureButtons() {
        let types = YNStoryEndpoint.allCases
        
        for type in types.enumerated() {
            var config = UIButton.Configuration.borderedProminent()
            config.cornerStyle = .capsule
            config.buttonSize = .small
            config.attributedTitle = AttributedString(type.element.name, attributes: AttributeContainer([.font : UIFont.systemFont(ofSize: 14, weight: .bold)]))
            config.image = type.element.image
            config.imagePlacement = .trailing
            config.imagePadding = 5
            config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .small)
            config.baseBackgroundColor = type.offset == 0 ? .systemBlue : .systemGray2
            
            let button = UIButton(configuration: config)
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
            button.tag = type.offset
            button.isSelected = type.offset == 0
            
            buttons.append(button)
            rootStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Selectors
extension YNStoryTypeSelector {
    @objc
    private func handleButtonTap(_ sender: UIButton){
        guard let selectedType = YNStoryEndpoint(rawValue: sender.tag), selectedType != self.selectedType else {
            return
        }
        
        self.selectedType = selectedType
        
        if let currentSelected = buttons.first(where: { $0.isSelected }) {
            currentSelected.isSelected = false
            currentSelected.configurationUpdateHandler = { button in
                var config = button.configuration
                config?.baseBackgroundColor = .systemGray2
                button.configuration = config
            }
            currentSelected.updateConfiguration()
        }
        
        sender.isSelected = true
        sender.configurationUpdateHandler = { button in
            var config = button.configuration
            config?.baseBackgroundColor = .systemBlue
            button.configuration = config
        }
        sender.updateConfiguration()
    }
}
// MARK: - Layout
extension YNStoryTypeSelector {
    private func layoutScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        let contentMargins = scrollView.contentLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: contentMargins.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentMargins.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentMargins.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentMargins.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentMargins.widthAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
    }
    
    private func layoutRootStackView() {
        contentView.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rootStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 1),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: rootStackView.trailingAnchor, multiplier: 1)
        ])
    }
}

// MARK: - Preview
#if canImport(SwiftUI)
import SwiftUI

struct YNStoryTypeSelector_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            let view = YNStoryTypeSelector()
            return view
        }
        .frame(height: 30)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
