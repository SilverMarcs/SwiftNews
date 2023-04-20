//
//  ArticleListView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 07/04/2023.
//

import SwiftUI

struct ArticleListView: View {
    
    let articles: [Article]
    @State private var selectedArticle: Article?
    
    var body: some View {
        List {
            ForEach(articles) { article in
                ArticleRowView(article: article)
                    .onTapGesture {
                        selectedArticle = article
                    }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
        .fullScreenCover(item: $selectedArticle) { selectedUrl in
            SafariView(url: selectedUrl.articleURL)
                .ignoresSafeArea()
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    // so this its child row views have access to the env object
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationStack {
            ArticleListView(articles: Article.previewData)
                .environmentObject(articleBookmarkVM)
        }
    }
}
