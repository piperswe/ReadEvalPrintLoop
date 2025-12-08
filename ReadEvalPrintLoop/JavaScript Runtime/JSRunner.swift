//
//  JSRunner.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore

actor JSRunner {
  private var context: JSContext

  init(context: JSContext) {
    self.context = context
  }

  func evaluate(script: String) -> JSValue? {
    return context.evaluateScript(script)
  }
}
