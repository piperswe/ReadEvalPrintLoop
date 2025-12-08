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
import HighlightSwift

struct HistoryItem: Identifiable {
    var id: UUID = UUID()
    var source: AttributedString
    var logs: [JSLogMessage] = []
    var result: JSValue?
    var exception: String?
    var resultIndex: Int?
}

func valueString(_ value: JSValue?) -> String {
    if value?.isUndefined ?? true {
        return "undefined"
    } else {
        let context = value!.context!
        let json = context.globalObject.forProperty("JSON").invokeMethod("stringify", withArguments: [value as Any])
        return json!.toString()
    }
}

func highlightJavaScript(_ code: String) async -> AttributedString {
    let highlight = Highlight()
    do {
        return try await highlight.attributedText(code, language: .javaScript, colors: .dark(.xcode))
    } catch {
        return AttributedString(stringLiteral: code)
    }
}

func displayValue(_ value: JSValue?) async -> AttributedString {
    let str = valueString(value)
    return await highlightJavaScript(str)
}

@Observable
class REPLInstance {
    var history: [HistoryItem] = []
    private var context: JSContext!
    private var results: [JSValue?] = []
    private var console: JSLibConsole = JSLibConsole(backend: JSLibConsoleNull())
    let tools: JSTools

    convenience init() {
        self.init(context: JSContext())
    }

    init(context: JSContext!) {
        self.context = context
        tools = JSTools(context: context)
        context.globalObject.setValue(context.globalObject, forProperty: "globalThis")
        context.globalObject.setValue(results, forProperty: "results")
        context.globalObject.setValue(JSValue(undefinedIn: context), forProperty: "exception")
        context.globalObject.setValue(JSValue(undefinedIn: context), forProperty: "last")
        console.attach(context: context)
    }
    
    @MainActor
    func appendHistory(_ item: HistoryItem) {
        history.append(item)
    }

    func evaluate(source: String!) async -> JSValue? {
        async let highlightedSource = highlightJavaScript(source)
        let consoleBackend = JSLibConsoleStore()
        self.console.backend = consoleBackend
        defer { self.console.backend = JSLibConsoleNull() }
        let result = context.evaluateScript(source)
        if let exception = context.exception {
            context.globalObject.setValue(exception, forProperty: "exception")
            appendHistory(HistoryItem(
                source: await highlightedSource,
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
            appendHistory(HistoryItem(
                source: await highlightedSource,
                logs: consoleBackend.messages,
                result: result,
                resultIndex: resultIndex
            ))
            return result
        }
    }
    
    var lastResultId: Int? { return results.isEmpty ? nil : results.count - 1 }
}
