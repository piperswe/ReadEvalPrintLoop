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
  var runtime: JavaScriptRuntime = JavaScriptRuntime()
  private var results: [JSValue?] = []
  private var console: JSLibConsole = JSLibConsole(backend: JSLibConsoleNull())

  func setupGlobals() async {
    await runtime.setupGlobalThis()
    await runtime.setGlobal(name: "results", value: results)
    await runtime.setGlobal(name: "exception", value: runtime.undefined)
    await runtime.setGlobal(name: "last", value: runtime.undefined)
    await console.attach(runtime: runtime)
    try! await loadDefaultLibraries(runtime: runtime)
  }

  @MainActor
  func appendHistory(_ item: HistoryItem) {
    history.append(item)
  }

  func evaluate(source: String!) async -> JSValue? {
    let consoleBackend = JSLibConsoleStore()
    self.console.backend = consoleBackend
    defer { self.console.backend = JSLibConsoleNull() }
    do {
      let maybeResult = try await runtime.evaluate(script: source)
      await runtime.setGlobal(name: "last", value: maybeResult)
      let resultIndex = results.count
      let result = maybeResult ?? runtime.undefined
      results.append(result)
      await runtime.setGlobal(name: "results", value: results)
      appendHistory(
        HistoryItem(
          source: source,
          logs: consoleBackend.messages,
          result: result,
          resultIndex: resultIndex
        ))
      return result
    } catch JavaScriptError.error(let e) {
      await runtime.setGlobal(name: "exception", value: e)
      appendHistory(
        HistoryItem(
          source: source,
          logs: consoleBackend.messages,
          exception: e
        ))
      return nil
    } catch let e {
      fatalError(e.localizedDescription)
    }
  }

  var lastResultId: Int? { return results.isEmpty ? nil : results.count - 1 }
}
