//
//  NewsAPI.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 10/04/2023.
//

import Foundation

struct NewsAPI {
    // singleton
    static let sharedInstance = NewsAPI()
    private init() {}
    
    private let apiKey = "5d4a458749f34041a4d7fa7cc49922d6"
    private let language =  "en"
    private let session = URLSession.shared
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

//    This function definition declares an async function fetch(from:category:) that takes a Category parameter, and returns an array of Articles.
//    The async keyword indicates that this function is an asynchronous function that can suspend execution while waiting for an asynchronous operation to complete
//    The throws keyword indicates that this function can throw an error if something goes wrong during the execution of the function.
    
    func fetch(from category: Category) async throws -> [Article] {
        try await fetchArticles(from: generateNewsURL(from: category))

    }
    
    func search(for query: String) async throws -> [Article] {
        try await fetchArticles(from: generateSearchURL(from: query))
    }
    
    private  func fetchArticles(from url: URL) async throws -> [Article] {
//        await because async
        let (data, response) = try await session.data(from: url)
        
//        In network programming, it’s common to retrieve data from an endpoint using a URLRequest, and to receive a response from the server in the form of an HTTPURLResponse.
//        However, the URLResponse class - from which HTTPURLResponse is derived - can also represent other types of responses, such as FTP, TelNet, or file system responses.
//        checking that cast from URLResponse to HTTPURLResponse was successful. If it wasn’t successful, it’s possible that the response isn’t what was expected
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Error Response")
        }
        
        switch response.statusCode {
            
        case (200...299), (400...499):
            let apiResponse = try jsonDecoder.decode(NewsAPIResponse.self, from: data)
            
            if apiResponse.status == "ok" {
                return apiResponse.articles ?? []
            } else {
                throw generateError(description: apiResponse.message ?? "Unexpected error occurred")
            }
            
        default:
            throw generateError(description: "Server error")
            
        }
    }
    
//    Helper function to generate error messages
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(domain: "NewsAPI", code: code, userInfo: [NSLocalizedDescriptionKey: "description"])
    }
    
    private func generateSearchURL(from query: String) -> URL {
        let percentEncodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        var url = "https://newsapi.org/v2/everything?"
        url += "apiKey=\(apiKey)"
        url += "&language=\(language)"
        url += "&q=\(percentEncodedString)"
        return URL(string: url)!
    }
    
    private func generateNewsURL(from category: Category) -> URL {
        var url = "https://newsapi.org/v2/top-headlines?"
        
        url += "apiKey=\(apiKey)"
        url += "&language=\(language)"
        url += "&category=\(category.rawValue)"
        
        return URL(string: url)!
    }


}
