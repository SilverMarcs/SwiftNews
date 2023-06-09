//
//  Article.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import Foundation

fileprivate let relativeDateFromatter = RelativeDateTimeFormatter()

struct Article {
    let source: Source
    
    let title: String?
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    var titleText: String {
        title ?? ""
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) · \(relativeDateFromatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
}

extension Article: Codable {}
extension Article: Equatable {}
extension Article: Identifiable {
    var id: String { url }
}

extension Article {
    
    static var previewData: [Article] {
        // finds file named news.json in project
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsAPIResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}




