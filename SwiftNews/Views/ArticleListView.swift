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
        .sheet(item: $selectedArticle) {
            SafariView(url: $0.articleURL)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArticleListView(articles: Article.previewData)
        }
    }
}
