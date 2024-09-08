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

import SwiftUI
import Translation

struct TranslationConfigView: View {
    @Environment(ViewModel.self) var viewModel

    @State private var selectedFrom: Locale.Language?
    @State private var selectedTo: Locale.Language?

    var selectedLanguagePair: LanguagePair {
        LanguagePair(selectedFrom: selectedFrom, selectedTo: selectedTo)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Select a source and a target language for translation; see whether the translation is supported.")

            List {
                Picker("Source", selection: $selectedFrom) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }
                Picker("Target", selection: $selectedTo) {
                    ForEach(viewModel.availableLanguages) { language in
                        Text(language.localizedName())
                            .tag(Optional(language.locale))
                    }
                }

                HStack {
                    Spacer()
                    if let isSupported = viewModel.isTranslationSupported {
                        Text(isSupported ? "✅" : "❌")
                            .font(.largeTitle)
                        if !isSupported {
                            Text("Translation between same language isn't supported.")
                        }
                    } else {
                        Image(systemName: "questionmark.circle")
                    }
                    Spacer()
                }
            }
        }
        .onChange(of: selectedLanguagePair) {
            Task {
                await performCheck()
            }
        }
        .onDisappear() {
            viewModel.reset()
        }
        .padding()
        .navigationTitle("Translation Config").navigationBarTitleDisplayMode(.inline)
    }

    private func performCheck() async {
        guard let selectedFrom = selectedFrom else { return }
        guard let selectedTo = selectedTo else { return }
    }
}

struct LanguagePair: Equatable {
    @State var selectedFrom: Locale.Language?
    @State var selectedTo: Locale.Language?

    static func == (lhs: LanguagePair, rhs: LanguagePair) -> Bool {
        return lhs.selectedFrom == rhs.selectedFrom &&
        lhs.selectedTo == rhs.selectedTo
    }
}

#Preview {
    TranslationConfigView()
}
