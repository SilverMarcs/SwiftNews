//
//  SearchTabView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 20/04/2023.
//

import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel.sharedInstance
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $searchVM.searchQuery) {
            Group {
                if searchVM.searchQuery.isEmpty {
                    suggstionsView
                }
            }
        }
        // to search api when whenpress enter or submit on keyboard
        .onChange(of: searchVM.searchQuery) { newValue in
            if newValue.isEmpty {
                searchVM.phase = .empty
            }
        }
        .onSubmit(of: .search, search)   // when we click search on keybaord, the func called search is called
    }
    
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
            
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            // When a user selects one of the previous search queries, it sets the searchQuery property of the searchVM view model to the selected value, which will cause a new search to be performed with the new query.
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                    search()
                }
            } else {
                EmptyPlaceHolderView(text: "Type your query to search", image: Image(systemName: "magnifyingglass"))
            }
            
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceHolderView(text: "No Articles matching search", image: Image(systemName: "magnifyingglass"))
          
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
                
            }
            
        default:
            EmptyView()
            
        }
        
    }
    
    // in the future, do this dynamically
    // The id parameter with \self is used as the identifier for each query. This is necessary when calling ForEach with an array of non-Identifiable values.
    // Put suggestions in searchVM ideally and then recompute it everytime based on search so far
    private var suggstionsView: some View {
        ForEach(["BTC", "iOS Apps", "Gaming", "Programmning", "Tesla", "Forbes"], id: \.self) { text in
            Button {
                searchVM.searchQuery = text
            } label: {
                Text(text)
            }
        }
    }
    
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
        }
        
        Task {
            await searchVM.searchArticle()
        }
    }
    
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
    }
}

