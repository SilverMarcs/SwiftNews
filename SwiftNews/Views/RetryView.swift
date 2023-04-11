//
//  RetryView.swift
//  SwiftNews
//
//  Created by Zabir Raihan on 11/04/2023.
//

import SwiftUI

struct RetryView: View {
    let text: String
    // This is empty because wherever this is reused, custom action will defined there. Check what is done for .failure case in NewsTabView
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Button(action: retryAction) {
                Text("Try Again")
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        RetryView(text: "Retry Action") {
            // nil
        }
    }
}
