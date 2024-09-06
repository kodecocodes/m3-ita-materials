/// Copyright (c) 2024 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
import Foundation
import Translation

@Observable
class ViewModel {
    
    var translatedText = ""
    var isTranslationSupported: Bool?
    
    var cafeReviews: [Review] = []
    
    var availableLanguages: [AvailableLanguage] = []
    
    var translateFrom: Locale.Language?
    var translateTo: Locale.Language?
    
    init() {
        cafeReviews = loadCafeReviews()
        prepareSupportedLanguages()
    }
    
    func reset() {
        // TODO: Reset cafe reviews
        isTranslationSupported = nil
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
        translateFrom = source
        translateTo = target
        
        guard let translateFrom = translateFrom else { return }
        
        let status = await LanguageAvailability().status(from: translateFrom, to: translateTo)
        
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
