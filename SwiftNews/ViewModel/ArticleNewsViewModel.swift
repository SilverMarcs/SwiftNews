//
//  ArticleNewsViewModel.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 11/04/2023.
//

// Based on the Model-View-ViewModel (MVVM) design pattern, the ViewModel is responsible for providing the view layer with all of the data and state that it needs
// to present to the user, and to handle user actions and input. The ViewModel itself is independent of the UI, and is designed to be easily testable, since it is not tied to any
// specific user interface.

// In short, a ViewModel in Swift is a class or struct that serves as an intermediary between a view and a model layer, and provides the view with any data that it needs.

// The ViewModel can have other responsibilities too, like formatting data received from a data source or providing data to a data source (for example when it is acting as a delegate).
// This can make the data processing logic independent of the View, facilitating maintenance and testing.

// Typically, the ViewModel takes data from the model layer and formats it in a way that can be easily consumed by a View. In SwiftUI, for example, a ViewModel might provide a View with
// an array of data that it can display using a ForEach loop.


import SwiftUI

//The DataFetchPhase enumeration has three possible cases:
//1. empty, which indicates that no data has been fetched yet.
//2. success(T), which indicates that data of type T has been successfully fetched.
//3. failure(Error), which indicates that an error occurred during the fetch, and includes an associated Error.
enum DataFetchPhase<T> {
    case empty
    case success(T)
    case failure(Error)
}

// we need this to kep track of when category was changed. we use the change oftimestamp as indicator of when to run our async function in NewsTabView
struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

//This class is used as a view model for an Article News screen in a SwiftUI application. The phase property is used to track the current state of the data fetch operation,
//and the selectedCategory property is used to keep track of which category the user has selected.
//By adopting the ObservableObject protocol and marking its properties with the @Published property wrapper, this view model is able to automatically update views when changes occur
// to its properties

// We can use this to automatically update views when we run async funcs. Previously we ahd to dispatchqueue to do it
// This ensures all our state changes happen on the main thread
// when we change phase, it will occur on the main thread.
// swift  requires you to update @Published properties on the main thread
@MainActor
class ArticleNewsViewModel: ObservableObject {
    @Published var phase = DataFetchPhase<[Article]>.empty
    @Published var fetchTaskToken: FetchTaskToken
    private let newsAPI = NewsAPI.sharedInstance
    
    init(articles: [Article]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    
    // if the task was cancelled, we dont want to do anything. This fixes the error overlay view when we launch app for the first time
    // Task is tied to the lifecycle of NewTabView
//    func loadArticles() async {
//        if Task.isCancelled { return }
//
//        phase = .empty
////        phase = .success([])   // to test no articles returned from api call
//        do  {
//            let articles = try await newsAPI.fetch(from: fetchTaskToken.category)
//            if Task.isCancelled { return }
//            // if the above line did not throw error, we set it to success
//            phase = .success(articles)
//        } catch {
//            if Task.isCancelled { return }
//            // if fails
//            print(error.localizedDescription)
//            phase = .failure(error)
//        }
//    }
    
    // comment out above for live fetching of data
    func loadArticles() async {
        phase = .success(Article.previewData)
    }
    
}


