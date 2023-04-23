//
//  ArticleSearchViewModel.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 20/04/2023.
//

import Foundation
import SwiftUI

@MainActor
class ArticleSearchViewModel: ObservableObject {
    @Published var phase: DataFetchPhase<[Article]> = .empty
    @Published var searchQuery = ""
    // The () after [String] denotes an empty argument list, indicating that history is a stored property of the enclosing type and not a computed property or method.
    @Published var history = [String]()
    
    private let historyDataStore = PlistDataStore<[String]>(filename: "histories")
    
    private let HISTORY_MAX_LIMIT = 10
    private let newsAPI = NewsAPI.sharedInstance
    
    static let sharedInstance = ArticleSearchViewModel()
    
    private init() {
        load()
    }
    
    func addHistory(_ text: String) {
        // The if let statement conditionally unwraps the optional index variable. If the variable is not nil, indicating that a matching index was found, then the code block enclosed in the if statement will execute.
        // if history already exists, just replace it and put it back on top.. we put itback on top in the final line of this func
        if let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() }) {
            history.remove(at: index)
        } else if history.count == HISTORY_MAX_LIMIT {
            history.remove(at: -1)
        }
        
        history.insert(text, at: 0)
        historiesUpdate()
        
    }
    
    func removeAllHistory() {
        history.removeAll()
        historiesUpdate()
    }
    
    func removeHistory(_ text: String) {
        // remove only if exists
        guard let index = history.firstIndex(where: { text.lowercased() == $0.lowercased() })
            else {
                return
            }
        history.remove(at: index)
        historiesUpdate()
    }
    
    
    func searchArticle() async {
        if Task.isCancelled { return }
        
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty {
            return
        }
        
        do {
            let articles = try await newsAPI.search(for: searchQuery)
            if Task.isCancelled { return }
            // if we change search query in input field at some point
            if searchQuery != self.searchQuery {
                return
            }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            phase = .failure(error)
        }
        
    }
    private func load() {
        Task {
            await self.history = historyDataStore.load() ?? []
        }
    }
    
    private func historiesUpdate() {
        let history = self.history
        Task {
            await historyDataStore.save(history)
        }
    }
    
}
