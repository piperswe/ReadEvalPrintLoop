//
//  REPLInstance.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore
import SwiftUI

@Observable
class REPLInstance {
  var history: [HistoryItem] = []
  private var runner: JSRunner
  private var context: JSContext
  private var results: [JSValue?] = []
  private var console: JSLibConsole = JSLibConsole(backend: JSLibConsoleNull())
  let tools: JSTools

  convenience init() {
    self.init(context: JSContext())
  }

  init(context: JSContext!) {
    self.context = context
    self.runner = JSRunner(context: context)
    tools = JSTools(context: context)
    context.globalObject.setValue(context.globalObject, forProperty: "globalThis")
    context.globalObject.setValue(results, forProperty: "results")
    context.globalObject.setValue(JSValue(undefinedIn: context), forProperty: "exception")
    context.globalObject.setValue(JSValue(undefinedIn: context), forProperty: "last")
    console.attach(context: context)

    try! loadDefaultLibraries(context: context)
  }

  @MainActor
  func appendHistory(_ item: HistoryItem) {
    history.append(item)
  }

  func evaluate(source: String!) async -> JSValue? {
    let consoleBackend = JSLibConsoleStore()
    self.console.backend = consoleBackend
    defer { self.console.backend = JSLibConsoleNull() }
    let result = await Task.detached(name: "JavaScript execution") {
      return await self.runner.evaluate(script: source)
    }.value
    if let exception = context.exception {
      context.globalObject.setValue(exception, forProperty: "exception")
      appendHistory(
        HistoryItem(
          source: source,
          logs: consoleBackend.messages,
          exception: exception.toString()
        ))
      context.exception = nil
      return nil
    } else {
      context.globalObject.setValue(result, forProperty: "last")
      let resultIndex = results.count
      let result = result ?? JSValue(undefinedIn: context)
      results.append(result)
      context.globalObject.setValue(results, forProperty: "results")
      appendHistory(
        HistoryItem(
          source: source,
          logs: consoleBackend.messages,
          result: result,
          resultIndex: resultIndex
        ))
      return result
    }
  }

  var lastResultId: Int? { return results.isEmpty ? nil : results.count - 1 }
}
