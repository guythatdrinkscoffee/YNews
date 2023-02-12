//
//  UIViewPreview.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/12/23.
//

import SwiftUI

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View){
        view = builder()
    }
    
    func makeUIView(context: Context) -> View {
        view
    }
    
    func updateUIView(_ uiView: View, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
