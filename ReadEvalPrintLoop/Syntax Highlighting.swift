//
//  Syntax Highlighting.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import HighlightSwift
import SwiftUI

private func setupHighlight() -> Highlight {
  let highlight = Highlight()
  Task.detached {
    // get HLJS loading in the background
    try await highlight.attributedText("1+1")
  }
  return highlight
}

private let highlight = setupHighlight()

func highlightJavaScript(
  _ code: String, colorScheme: ColorScheme = .light, theme: HighlightTheme = .xcode
) async
  -> AttributedString
{
  let colors = colorScheme == .dark ? HighlightColors.dark(theme) : HighlightColors.light(theme)
  do {
    return try await highlight.attributedText(code, language: .javaScript, colors: colors)
  } catch {
    return AttributedString(stringLiteral: code)
  }
}
