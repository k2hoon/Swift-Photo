//
//  PHLimitAccessView.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import SwiftUI
import Photos

struct PHLimitAccessView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return PHLimitAccessViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

