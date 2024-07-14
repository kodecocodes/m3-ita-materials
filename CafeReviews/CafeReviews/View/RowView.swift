//
//  RowView.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import SwiftUI

struct RowView: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(.accentColor)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    RowView(title: "SwiftUI",
            subtitle: "A SwiftUI control for translation",
            imageName: "swift")
}
