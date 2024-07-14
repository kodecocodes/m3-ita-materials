//
//  ContentView.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(ViewModel.self) private var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.cafeReviews) { review in
                NavigationLink {
//                        ViewTranslationView()
                } label: {
                    RowView(title: review.name,
                            subtitle: review.address,
                            imageName: "lightswitch.on")
                }
            }
            .navigationTitle("Cafe Reviews")
        }
    }
}

#Preview {
    ContentView()
}
