//
//  ArticleRowView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import SwiftUI

struct ArticleRowView: View {
    
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
                    
                    Menu {
                        
                         Button(action: {}) {
                            Label("Bookmark", systemImage: "bookmark")
                         }
                         
                         Button(action: {presentShareSheet(url: article.articleURL)}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                         }
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing)
                }
            }
        }
        .padding(.all)
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
    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[1])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
    }
}
