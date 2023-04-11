//
//  Category.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 10/04/2023.
//

import Foundation

enum Category: String, CaseIterable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    // So that we may associate certain categories with our desired title
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
}

// what is this?
extension Category: Identifiable {
    var id: Self { self }
}
