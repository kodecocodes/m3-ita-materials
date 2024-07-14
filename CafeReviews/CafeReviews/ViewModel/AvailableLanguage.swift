//
//  AvailableLanguage.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import Foundation

struct AvailableLanguage: Identifiable, Hashable, Comparable {
    
    var id: Self { self }
    let locale: Locale.Language

    func localizedName() -> String {
        let locale = Locale.current
        let shortName = shortName()

        guard let localizedName = locale.localizedString(forLanguageCode: shortName) else {
            return "Unknown language code"
        }

        return "\(localizedName) (\(shortName))"
    }

    private func shortName() -> String {
        "\(locale.languageCode ?? "")-\(locale.region ?? "")"
    }

    static func <(lhs: AvailableLanguage, rhs: AvailableLanguage) -> Bool {
        return lhs.localizedName() < rhs.localizedName()
    }
}
