//
//  ConsoleTests.swift
//  ReadEvalPrintLoopTests
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore
import Testing

@testable import ReadEvalPrintLoop

@MainActor
struct JSLibConsoleTests {
  // Helper to prepare a JSContext with console attached and a store backend
  private func makeContextAndStore() -> (JSContext, JSLibConsoleStore) {
    let context = JSContext()!
    let store = JSLibConsoleStore()
    let console = JSLibConsole(backend: store)
    console.attach(context: context)
    return (context, store)
  }

  @Test func attachesConsoleObjectWithMethods() {
    let (context, _) = makeContextAndStore()

    let consoleObj = context.globalObject.forProperty("console")
    #expect(consoleObj!.isObject)

    // Validate each method exists and is a function from JS perspective.
    let typeofLog = context.evaluateScript("typeof console.log")
    #expect(typeofLog?.toString() == "function")

    let typeofWarn = context.evaluateScript("typeof console.warn")
    #expect(typeofWarn?.toString() == "function")

    let typeofError = context.evaluateScript("typeof console.error")
    #expect(typeofError?.toString() == "function")
  }

  @Test func logsWithCorrectLevelsAndOrder() {
    let (context, store) = makeContextAndStore()

    let result = context.evaluateScript(
      "console.log('a'); console.warn('b'); console.error('c');")
    #expect(result?.isUndefined == true)
    #expect(context.exception == nil)

    #expect(store.messages.count == 3)
    #expect(store.messages[0].level == .log)
    #expect(store.messages[1].level == .warn)
    #expect(store.messages[2].level == .error)

    #expect(store.messages[0].message.count == 1)
    #expect(store.messages[0].message[0].toString() == "a")
    #expect(store.messages[1].message[0].toString() == "b")
    #expect(store.messages[2].message[0].toString() == "c")
  }

  @Test func forwardsVariadicArgumentsAsJSValues() {
    let (context, store) = makeContextAndStore()

    let result = context.evaluateScript("console.log('x', 42, true, null, undefined)")
    #expect(result?.isUndefined == true)
    #expect(context.exception == nil)

    #expect(store.messages.count == 1)
    let msg = store.messages[0]
    #expect(msg.level == .log)
    #expect(msg.message.count == 5)

    // 'x'
    #expect(msg.message[0].isString)
    #expect(msg.message[0].toString() == "x")

    // 42
    #expect(msg.message[1].isNumber)
    #expect(msg.message[1].toInt32() == 42)

    // true
    #expect(msg.message[2].isBoolean)
    #expect(msg.message[2].toBool() == true)

    // null
    #expect(msg.message[3].isNull)

    // undefined
    #expect(msg.message[4].isUndefined)
  }

  @Test func multipleCallsAccumulateMessages() {
    let (context, store) = makeContextAndStore()

    _ = context.evaluateScript(
      """
        console.log('one');
        console.log('two');
        console.warn('three');
      """)
    #expect(context.exception == nil)

    #expect(store.messages.count == 3)
    #expect(store.messages.map { $0.level } == [.log, .log, .warn])
    #expect(store.messages.map { $0.message.first!.toString() } == ["one", "two", "three"])
  }
}
