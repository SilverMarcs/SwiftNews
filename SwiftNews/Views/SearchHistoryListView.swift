//
//  SearchHistoryListView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 23/04/2023.
//

import SwiftUI

struct SearchHistoryListView: View {
    @ObservedObject var searchVM: ArticleSearchViewModel
    let onSubmit: (String) -> ()
    
    var body: some View {
        List {
            HStack {
                Text("Recent Searches")
                    .fontWeight(.bold)
                Spacer()
                Button("Clear") {
                    searchVM.removeAllHistory()
                }
                .foregroundColor(.accentColor)
            }
            .listSectionSeparator(.hidden)
            
            // \.self needed becasue String for the history items are not Identifiable by default
            ForEach(searchVM.history, id: \.self) { history in
                Button(history) {
                    onSubmit(history)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        searchVM.removeHistory(history)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SearchHistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryListView(searchVM: ArticleSearchViewModel.sharedInstance) {_ in
            
        }
    }
}
