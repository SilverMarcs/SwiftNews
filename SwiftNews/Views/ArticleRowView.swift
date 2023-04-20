//
//  ArticleRowView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import SwiftUI

struct ArticleRowView: View {
    
    // will try to get  the articleBookMarkVM from environment. If it cannot find it up its heirearchy, it will crash
    @EnvironmentObject var articleBookmarkVM: ArticleBookmarkViewModel
    
    let imageRadius = 10
    let article: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: article.imageURL) {
                phase in
                switch phase {
                case .empty:
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(CGFloat(imageRadius))
                    
                case .failure:
                    HStack {
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large)
                        Spacer()
                    }
                    
                @unknown default:
                    fatalError()
                }
            }
            .frame(minWidth: 300, minHeight: 200)
            .background(Color.gray.opacity(0.30))
            .cornerRadius(CGFloat(imageRadius))
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.titleText)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Spacer()
                
                HStack {
                    Text(article.captionText)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button {
                        toggleBookmark(for: article)
                    } label: {
                        Image(systemName: articleBookmarkVM.isBookmarked(for: article) ? "bookmark.fill" : "bookmark")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 15))
                    
                    Menu {
                        
                         Button(action: {}) {
                            Label("Show More", systemImage: "hand.thumbsup")
                         }
                        
                        Button(action: {}) {
                           Label("Show Less", systemImage: "hand.thumbsdown")
                        }
                         
                         Button(action: {presentShareSheet(url: article.articleURL)}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                         }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(90))
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .padding(.all)
    }
    
    private func toggleBookmark(for article: Article) {
        if articleBookmarkVM.isBookmarked(for: article) {
            articleBookmarkVM.removeBookmark(for: article)
        } else {
            articleBookmarkVM.addBookmark(for: article)
        }
    }
    
}

// To open iOS Share Sheet modal
extension View {
    func presentShareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController?
            .present(activityVC, animated: true)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    
    // so this its child views have access to the env object
    @StateObject static var articleBookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[1])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
        .environmentObject(articleBookmarkVM)
    }
}
