//
//  ViewModel.swift
//  CafeReviews
//
//  Created by Zahidur Rahman Faisal on 15/7/2024.
//

import Foundation
import Translation

@Observable
class ViewModel {
    
    var translatedText = ""
    var isTranslationSupported: Bool?
    
    var cafeReviews: [Review] = []

    func reset() {
        // TODO: Reset cafe reviews
        isTranslationSupported = nil
    }

    var availableLanguages: [AvailableLanguage] = []

    init() {
        cafeReviews = loadCafeReviews()
        prepareSupportedLanguages()
    }

    func prepareSupportedLanguages() {
        Task { @MainActor in
            let supportedLanguages = await LanguageAvailability().supportedLanguages
            availableLanguages = supportedLanguages.map {
                AvailableLanguage(locale: $0)
            }.sorted()
        }
    }
    
    func loadCafeReviews() -> [Review] {
        if let jsonData = loadJSON(filename: "cafe_reviews") {
            if let reviews = parse(jsonData: jsonData) {
                print("reviews: \(reviews)")
                return reviews
            }
        }
        return []
    }
}

// MARK: - Single string of text

extension ViewModel {
    func translate(text: String, using session: TranslationSession) async {
        do {
            let response = try await session.translate(text)
            translatedText = response.targetText
        } catch {
            // Handle any errors.
        }
    }
}

// MARK: - Batch of strings
/*
extension ViewModel {
    func translateAllAtOnce(using session: TranslationSession) async {
        Task { @MainActor in
            let requests: [TranslationSession.Request] = cafeReviews.map {
                // Map each item into a request.
                TranslationSession.Request(sourceText: $0)
            }

            do {
                let responses = try await session.translations(from: requests)
                cafeReviews = responses.map {
                    // Update each item with the translated result.
                    $0.targetText
                }
            } catch {
                // Handle any errors.
            }
        }
    }
}

// MARK: - Batch of strings as a sequence

extension ViewModel {
    func translateSequence(using session: TranslationSession) async {
        Task { @MainActor in
            let requests: [TranslationSession.Request] = cafeReviews.enumerated().map { (index, string) in
                // Assign each request a client identifier.
                    .init(sourceText: string, clientIdentifier: "\(index)")
            }

            do {
                for try await response in session.translate(batch: requests) {
                    // Use the returned client identifier (the index) to map the request to the response.
                    guard let index = Int(response.clientIdentifier ?? "") else { continue }
                    cafeReviews[index] = response.targetText
                }
            } catch {
                // Handle any errors.
            }
        }
    }
}
 */

// MARK: - Language availability

extension ViewModel {
    func checkLanguageSupport(from source: Locale.Language, to target: Locale.Language) async {
        let availability = LanguageAvailability()
        let status = await availability.status(from: source, to: target)

        switch status {
        case .installed, .supported:
            isTranslationSupported = true
        case .unsupported:
            isTranslationSupported = false
        @unknown default:
            print("Not supported")
        }
    }
}

// MARK: - JSON Parsing
// Function to read JSON file from the "Data" folder
func loadJSON(filename fileName: String) -> Data? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error reading JSON file: \(error)")
        }
    }
    return nil
}

// Function to decode JSON data
func parse(jsonData: Data) -> [Review]? {
    let decoder = JSONDecoder()
    do {
        let decodedData = try decoder.decode([Review].self, from: jsonData)
        return decodedData
    } catch {
        print("Error decoding JSON data: \(error)")
    }
    return nil
}
