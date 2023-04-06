//
//  ArticleRowView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import SwiftUI

struct ArticleRowView: View {
    
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
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title!)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                HStack {
                    Text(article.captionText)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "bookmark")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                }
            }
        }
        .padding(.all)
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ArticleRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
    }
}
