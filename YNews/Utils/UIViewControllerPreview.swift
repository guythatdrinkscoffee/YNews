//
//  UIViewControllerPreview.swift
//  YNews
//
//  Created by J Manuel Zaragoza on 2/10/23.
//

import SwiftUI

struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let vc: ViewController
    
    init(_ builder: @escaping () -> ViewController){
        vc = builder()
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        vc
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
}
