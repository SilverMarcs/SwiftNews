//
//  ArticleBookmarkViewModel.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 16/04/2023.
//

import SwiftUI

@MainActor
class ArticleBookmarkViewModel: ObservableObject {
    // means cannot be set from outside
    @Published private(set) var bookmarks: [Article] = []
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else {
            return
        }
        bookmarks.insert(article, at: 0)
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
    }
    
}
