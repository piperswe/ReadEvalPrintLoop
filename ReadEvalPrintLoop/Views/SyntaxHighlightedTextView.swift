//
//  SyntaxHighlightedTextView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//

import SwiftUI

struct SyntaxHighlightedTextView: View {
  @Environment(\.colorScheme) private var colorScheme: ColorScheme
  var source: String
  var prefix: AttributedString
  @State var highlightedSource: AttributedString

  init(source: String, prefix: AttributedString = AttributedString("")) {
    self.source = source
    self.prefix = prefix
    highlightedSource = AttributedString(source)
  }

  var body: some View {
    Text(prefix + highlightedSource)
      .font(.system(.body, design: .monospaced))
      .task(id: colorScheme) {
        highlightedSource = await highlightJavaScript(
          source,
          colorScheme: colorScheme
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
  }.padding(20)
}
