//
//  JavaScriptRuntimeTests.swift
//  ReadEvalPrintLoopTests
//
//  Created by Piper McCorkle on 12/7/25.
//

import Foundation
import JavaScriptCore
import Testing

@testable import ReadEvalPrintLoop

@MainActor
struct JSRunnerTests {

  @Test
  func evaluatesSimpleExpression() async {
    let ctx = JSContext()!
    let runner = JSRunner(context: ctx)

    let value = await runner.evaluate(script: "1 + 2")
    #expect(value != nil)
    #expect(value!.isNumber)
    #expect(value!.toInt32() == 3)
    #expect(ctx.exception == nil)
  }

  @Test
  func returnsUndefinedForStatements() async {
    let ctx = JSContext()!
    let runner = JSRunner(context: ctx)

    let value = await runner.evaluate(script: "var x = 42;")
    #expect(value != nil)
    #expect(value!.isUndefined)
    #expect(ctx.exception == nil)

    // Follow-up expression should still work and see prior state
    let next = await runner.evaluate(script: "x + 1")
    #expect(next!.toInt32() == 43)
  }
}

@MainActor
struct REPLInstanceTests {

  private func makeREPL() -> (REPLInstance, JSContext) {
    let context = JSContext()!
    let repl = REPLInstance(context: context)
    return (repl, context)
  }

  @Test
  func initialGlobalsAreSet() {
    let (_, ctx) = makeREPL()

    // globalThis should be set and equal to the global object (`this` in non-strict top-level)
    let hasGlobalThis = ctx.evaluateScript("typeof globalThis !== 'undefined'")!.toBool()
    #expect(hasGlobalThis == true)
    let sameAsThis = ctx.evaluateScript("globalThis === this")!.toBool()
    #expect(sameAsThis == true)

    // last and exception should be initialized to undefined
    #expect(ctx.globalObject.forProperty("last")!.isUndefined)
    #expect(ctx.globalObject.forProperty("exception")!.isUndefined)

    // results should exist and be an array of length 0
    let isArray = ctx.evaluateScript("Array.isArray(results)")!.toBool()
    #expect(isArray == true)
    let length = ctx.globalObject.forProperty("results")!.forProperty("length")!.toInt32()
    #expect(length == 0)
  }

  @Test
  func evaluateSuccessUpdatesStateAndHistory() async {
    let (repl, ctx) = makeREPL()

    let result = await repl.evaluate(source: "1 + 2")
    #expect(result != nil)
    #expect(result!.toInt32() == 3)

    // JSContext did not capture an exception
    #expect(ctx.exception == nil)

    // last updated
    let last = ctx.globalObject.forProperty("last")
    #expect(last?.toInt32() == 3)

    // results appended and re-exposed on global
    let results = ctx.globalObject.forProperty("results")!
    let length = results.forProperty("length")!.toInt32()
    #expect(length == 1)
    #expect(results.atIndex(0)!.toInt32() == 3)

    // history updated
    #expect(repl.history.count == 1)
    let item = repl.history[0]
    #expect(item.source == "1 + 2")
    #expect(item.logs.isEmpty)
    #expect(item.exception == nil)
    #expect(item.result != nil)
    #expect(item.result!.toInt32() == 3)
    #expect(item.resultIndex == 0)

    // lastResultId reflects last index
    #expect(repl.lastResultId == 0)
  }

  @Test
  func evaluateExceptionAppendsHistoryAndSetsException() async {
    let (repl, ctx) = makeREPL()

    let value = await repl.evaluate(source: "throw new Error('boom')")
    #expect(value == nil)

    // Context exception should have been cleared after handling
    #expect(ctx.exception == nil)

    // Global 'exception' should be set to the thrown error
    let ex = ctx.globalObject.forProperty("exception")
    #expect(ex != nil)
    #expect(ex!.toString()?.contains("boom") == true)

    // 'last' should still be undefined (no successful evaluation happened)
    let last = ctx.globalObject.forProperty("last")
    #expect(last!.isUndefined)

    // History entry recorded correctly
    #expect(repl.history.count == 1)
    let item = repl.history[0]
    #expect(item.source == "throw new Error('boom')")
    #expect(item.exception?.contains("boom") == true)
    #expect(item.result == nil)
    #expect(item.resultIndex == nil)
  }

  @Test
  func logsAreCapturedFromConsole() async {
    let (repl, _) = makeREPL()

    let value = await repl.evaluate(source: "console.log('a', 7); 4")
    #expect(value != nil)
    #expect(value!.toInt32() == 4)

    #expect(repl.history.count == 1)
    let entry = repl.history[0]
    #expect(entry.logs.count == 1)
    let msg = entry.logs[0]
    #expect(msg.level == .log)
    #expect(msg.message.count == 2)
    #expect(msg.message[0].toString() == "a")
    #expect(msg.message[1].toInt32() == 7)
  }

  @Test
  func multipleEvaluationsAccumulateResultsAndHistory() async {
    let (repl, ctx) = makeREPL()

    let a = await repl.evaluate(source: "1")
    #expect(a!.toInt32() == 1)
    let b = await repl.evaluate(source: "2")
    #expect(b!.toInt32() == 2)

    // Results array has 2 items
    let results = ctx.globalObject.forProperty("results")!
    #expect(results.forProperty("length")!.toInt32() == 2)
    #expect(results.atIndex(0)!.toInt32() == 1)
    #expect(results.atIndex(1)!.toInt32() == 2)

    // last reflects last result
    #expect(ctx.globalObject.forProperty("last")!.toInt32() == 2)

    // History contains 2 entries with proper result indices
    #expect(repl.history.count == 2)
    #expect(repl.history[0].resultIndex == 0)
    #expect(repl.history[1].resultIndex == 1)

    // lastResultId equals last index
    #expect(repl.lastResultId == 1)
  }
}

@MainActor
struct HistoryItemTests {

  @Test
  func defaultInitializationHasExpectedDefaults() {
    let item = HistoryItem(source: "x + y")
    #expect(item.source == "x + y")
    #expect(item.logs.isEmpty)
    #expect(item.result == nil)
    #expect(item.exception == nil)
    #expect(item.resultIndex == nil)
  }

  @Test
  func uniqueIdsAreGenerated() {
    let a = HistoryItem(source: "1")
    let b = HistoryItem(source: "2")
    #expect(a.id != b.id)
  }
}
