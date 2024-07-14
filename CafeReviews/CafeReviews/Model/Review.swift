//
//  Review.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import Foundation

struct Review: Identifiable, Codable {
    let id = UUID()
    let name: String
    let address: String
    let description: String
    let highlights: String
    let price_range: String
    let rating: Double
}
