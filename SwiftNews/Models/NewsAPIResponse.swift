//
//  NewsAPIReponse.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 06/04/2023.
//

import Foundation

struct NewsAPIResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Article]?
    
    let code: String?
    let message: String?
}
