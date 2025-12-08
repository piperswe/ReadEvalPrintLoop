import Foundation
import SwiftUI
import Testing

@testable import ReadEvalPrintLoop

@MainActor
struct SyntaxHighlightingTests {

  @Test
  func returnsSameStringLight() async {
    let code = "const a = 1 + 2;"
    let highlighted = await highlightJavaScript(code, colorScheme: .light)

    // Underlying string should be preserved
    #expect(String(highlighted.characters) == code)
  }

  @Test
  func returnsSameStringDark() async {
    let code = "let x = { foo: 'bar' };"
    let highlighted = await highlightJavaScript(code, colorScheme: .dark)

    // Underlying string should be preserved
    #expect(String(highlighted.characters) == code)
  }

  @Test
  func appliesColorForNonTrivialJS() async {
    // Include keywords, numbers, strings, punctuation, and a comment
    let code = "function foo(x){ return x + 1; } // comment"
    let highlighted = await highlightJavaScript(code, colorScheme: .light)

    var runCount = 0
    var hasColor = false
    for run in highlighted.runs {
      runCount += 1
      if run.attributes.strokeColor != nil {
        hasColor = true
        break
      }
    }

    // Expect at least one attribute run for a non-trivial snippet
    #expect(runCount >= 1)
    #expect(hasColor == true)
  }

  @Test
  func handlesEmptyStringGracefully() async {
    let code = ""
    let highlighted = await highlightJavaScript(code, colorScheme: .light)

    // Underlying string should be preserved and empty; no crash
    #expect(String(highlighted.characters) == "")
  }
}
