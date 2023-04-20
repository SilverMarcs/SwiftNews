//
//  SwiftNewsApp.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import SwiftUI

@main
struct SwiftNewsApp: App {
    
    @StateObject var articleBookMarkVM = ArticleBookmarkViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Supplies an ObservableObject to a view subhierarchy.
                .environmentObject(articleBookMarkVM)
        }
    }
}
