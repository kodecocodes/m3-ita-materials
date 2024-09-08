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

struct DetailView: View {

  var review: Review? = nil

  var body: some View {
    let translatableText = review?.description ?? ""
    VStack(alignment: .leading) {

      Button("Translate") {
        // Show Traslation Overlay UI
      }
      .buttonStyle(.bordered)
      .frame(maxWidth: .infinity)

      Text(verbatim: review?.description ?? "")
        .font(.headline)
        .padding(.top, 40)

      Text(verbatim: "Highlights")
        .font(.title3)
        .padding(.top, 16)
      Text(verbatim: review?.highlights ?? "")

      Text(verbatim: "Address")
        .font(.title3)
        .padding(.top, 16)
      Text(verbatim: review?.address ?? "")

      Text(verbatim: "Price Range: \(review?.price_range ?? "$$")")
        .font(.subheadline)
        .padding(.top, 8)

      Text(verbatim: "Rating: \(review?.rating ?? 3) / 5")
        .font(.subheadline)

      Spacer()
    }
    .navigationTitle(review?.name ?? "")
    .scenePadding()
  }
}

#Preview {
  DetailView()
}
