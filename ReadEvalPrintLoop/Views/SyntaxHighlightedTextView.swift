//
//  SyntaxHighlightedTextView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//

import HighlightSwift
import SwiftUI

struct SyntaxHighlightedTextView: View {
  @Environment(\.colorScheme) private var colorScheme: ColorScheme
  var source: String
  var prefix: AttributedString
  var theme: HighlightTheme
  @State var highlightedSource: AttributedString

  init(
    source: String, prefix: AttributedString = AttributedString(""), theme: HighlightTheme = .xcode
  ) {
    self.source = source
    self.prefix = prefix
    self.theme = theme
    highlightedSource = AttributedString(source)
  }

  var body: some View {
    Text(prefix + highlightedSource)
      .font(.system(.body, design: .monospaced))
      .task(id: colorScheme) {
        highlightedSource = await highlightJavaScript(
          source,
          colorScheme: colorScheme,
          theme: theme
        )
      }
  }
}

#Preview {
  VStack(alignment: .leading) {
    SyntaxHighlightedTextView(source: "const x = 1 + 5; class MyClass {};")
    SyntaxHighlightedTextView(
      source: "const x = 1 + 5; class MyClass {};",
      prefix: "> "
    )
    SyntaxHighlightedTextView(
      source: "const x = 1 + 5; class MyClass {};",
      prefix: "> ",
      theme: .github
    )
    SyntaxHighlightedTextView(
      source: "const x = 1 + 5; class MyClass {};",
      prefix: "> ",
      theme: .solarized
    )
    SyntaxHighlightedTextView(
      source: "const x = 1 + 5; class MyClass {};",
      prefix: "> ",
      theme: .grayscale
    )
  }.padding(20)
}
