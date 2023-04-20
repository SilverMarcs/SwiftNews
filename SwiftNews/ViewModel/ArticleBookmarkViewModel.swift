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
    private let bookmarkStore = PlistDataStore<[Article]>(filename: "bookmarks")
    
    static let shared = ArticleBookmarkViewModel()
    
    private init() {
        Task {
            await load()
        }
    }
    
    private func load() async {
        bookmarks = await bookmarkStore.load() ?? []
    }
    
    func isBookmarked(for article: Article) -> Bool {
        bookmarks.first { article.id == $0.id } != nil
    }
    
    func addBookmark(for article: Article) {
        guard !isBookmarked(for: article) else {
            return
        }
        bookmarks.insert(article, at: 0)
        bookmarkUpdate()
    }
    
    func removeBookmark(for article: Article) {
        guard let index = bookmarks.firstIndex(where: { $0.id == article.id }) else {
            return
        }
        bookmarks.remove(at: index)
        bookmarkUpdate()
    }
    
    // need to update the DataStore when we add or remove bookmark
    private func bookmarkUpdate() {
        let bookmarks = self.bookmarks
        Task {
            await bookmarkStore.save(bookmarks)
        }
    }
    
}
