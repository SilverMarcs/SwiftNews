//
//  NewsTabView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 11/04/2023.
//

import SwiftUI

struct NewsTabView: View {
    
// Use @StateObject for any observable properties that you initialize in Ihe view that uses it. If the ObservableObject
// instance is created externally and passed to the view that uses it mark your property with @ObservedObject.
    
    // Whenever NewsTabView gets updated or redrawn, it will keep the reference to this StateObject. It wont recreate everytime
    // If we we ObservedObject, it will do the opposite. Performance cost
    @StateObject var articleNewsVM = ArticleNewsViewModel()
    
    // the .task modifier is nice because it handles both onAppear and onChange. Essentially, change in something will cause to do the loadJob function. Plus it will also stop previous loadJob if we switch category for example.
    // task will trigger loadJob whenever timestamp in fetchTaskToken is updated
    var body: some View {
        NavigationView {
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .task(id: articleNewsVM.fetchTaskToken, loadTask)
                .refreshable(action: refreshTask)
                .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
                .navigationBarItems(trailing: categoryMenu)
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
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        
        default:
            EmptyView()
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
    
    @Sendable
    private func loadTask() async {
        Task { await articleNewsVM.loadArticles() }
    }
    
    // when we refresh, we set category to whatever is the current category but change Date so that it triggers change
    
    
    private func refreshTask() {
        DispatchQueue.main.async {
                    articleNewsVM.fetchTaskToken = FetchTaskToken(category: articleNewsVM.fetchTaskToken.category, token: Date())
                }
    }
    
    // Picker is a unique picker amonng array of elements
    // Category.allCases is an automatically generated static property that contains an array of all the cases of an enum type called Category.
    // provides an easy way to iterate over all the possible values of an enum.
    // The tag(_:) method is then used to associate each category option with its corresponding Category instance, using the category instance itself as the tag value. This creates a mapping between the category’s text value (which is displayed to the user) and the category instance (which is used as the selection value).
    private var categoryMenu: some View {
        Menu {
            Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                ForEach(Category.allCases) {
                    Text($0.text).tag($0)
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
    
}


struct NewsTabView_Previews: PreviewProvider {
    
    // so this its child views have access to the env object
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NewsTabView(articleNewsVM: ArticleNewsViewModel(articles: Article.previewData))
            .environmentObject(articleBookmarkVM)
    }
}
