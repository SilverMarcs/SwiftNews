//
//  SafariView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 07/04/2023.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        
        configuration.barCollapsingEnabled = true
        configuration.entersReaderIfAvailable = true
        return SFSafariViewController(url: url, configuration: configuration)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
