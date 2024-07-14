//
//  CafeReviewsApp.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import SwiftUI

@main
struct CafeReviewsApp: App {
    
    @State private var model = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(model)
        }
    }
}
