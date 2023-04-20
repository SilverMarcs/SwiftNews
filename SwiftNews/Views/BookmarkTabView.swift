//
//  BookmarkTabView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 16/04/2023.
//

import SwiftUI

struct BookmarkTabView: View {
    
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    @State var searchText: String = ""
    
    var body: some View {
        let articles = self.articles
        
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView(isEmpty: articles.isEmpty))
                .navigationTitle("Saved Articles")
        }
        // $ does binding stuff
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
    
    // might be expensive
    // if searchtext empty return all bookmarks, else do chcking if matches  any then return those.
    // in above function we use this, instead of articleBookmarkVM directly
    private var articles: [Article] {
        if searchText.isEmpty {
            return articleBookmarkVM.bookmarks
        }
        return articleBookmarkVM.bookmarks
            .filter {
                $0.title!.lowercased().contains(searchText.lowercased()) ||
                $0.descriptionText.lowercased().contains(searchText.lowercased())
            }
    }
    
    @ViewBuilder
    func overlayView(isEmpty: Bool) -> some View {
        if isEmpty {
            EmptyPlaceHolderView(text: "No bookmarks saved",
                                 image: Image(systemName: "bookmark"))
        }
    }
}

struct BookmarkTabView_Previews: PreviewProvider {
    
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        BookmarkTabView()
            .environmentObject(articleBookmarkVM)
    }
}
