//
//  NewsTabView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 11/04/2023.
//

import SwiftUI

struct NewsTabView: View {
    
// you should use @StateObject for any observable properties that you initialize in Ihe view that uses it. If the ObservableObject
// instance is created externally and passed to the view that uses it mark your property with @ObservedObject.
    
    // Whenever NewsTabView gets updated or redrawn, it will keep the reference to this StateObject. It wont recreate everytime
    // If we we ObservedObject, it will do the opposite. Performance cost
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .refreshable {
                    
                }
                .onAppear {
                    // fix warning
                    async {
                        await articleNewsVM.loadArticles()
                    }
                }
                .navigationTitle(articleNewsVM.selectedCategory.text)
        }

    }
    
    
    // Overlay to show when empty articles / none loaded
    // @ViewBuilder is a property wrapperunction or closure to build and return multiple views in a more concise syntax.
    // Normally, functions in SwiftUI can only return a single view.
    @ViewBuilder
    private var overlayView: some View {
        switch articleNewsVM.phase {
            
        case .empty:
            ProgressView()
        
        // if no error but no articles were retrieved
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceHolderView(text: "No articles found", image: nil)
        
        case .failure(let error):
            RetryView(text: error.localizedDescription) {
            // TODO: Refresh News api
        }
        
        default: EmptyView()
    }
    }
    
    
    // It checks whether the current value of articleNewsVM.phase is in the .success case by using the if case let syntax, which allows
    // you to conditionally bind an associated value to a variable.
    // If the current value of articleNewsVM.phase is in the .success case, the articles array is bound to a new constant called articles.
    // Finally, articles is returned from the function.
    private var articles: [Article] {
        if case let .success(articles) = articleNewsVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    
}


struct NewsTabView_Previews: PreviewProvider {
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
    }
}
