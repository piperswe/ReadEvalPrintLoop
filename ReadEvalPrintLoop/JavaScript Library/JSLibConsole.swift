//
//  Console.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore

func generateVariadic(
  context: JSContext, name: String, f: @convention(block) @escaping (JSValue) -> JSValue
) -> JSValue {
  let generator = context.evaluateScript("f => function \(name)(...args) { return f(args); }")!
  if context.exception != nil {
    fatalError("exception evaluating generator: \(context.exception.toString()!)")
  }
  let generated = generator.call(withArguments: [f])!
  if context.exception != nil {
    fatalError("exception calling generator: \(context.exception.toString()!)")
  }
  return generated
}

enum JSLogLevel {
  case log
  case warn
  case error
}

struct JSLogMessage: Identifiable {
  var id: UUID = UUID()
  var level: JSLogLevel
  var message: [JSValue]
}

protocol JSLibConsoleBackend {
  func log(_ message: JSLogMessage)
}

class JSLibConsoleStore: JSLibConsoleBackend {
  var messages: [JSLogMessage] = []

  func log(_ message: JSLogMessage) {
    messages.append(message)
  }
}

class JSLibConsoleNull: JSLibConsoleBackend {
  func log(_ message: JSLogMessage) {
    let _ = message
  }
}

class JSLibConsole {
  var backend: JSLibConsoleBackend

  init(backend: JSLibConsoleBackend) {
    self.backend = backend
  }

  func attach(context: JSContext) {
    let console = JSValue(newObjectIn: context)!
    let log = generateVariadic(context: context, name: "log") { args in
      let args = toArrayOfValues(value: args)!
      self.backend.log(JSLogMessage(level: .log, message: args))
      return JSValue(undefinedIn: context)
    }
    console.setValue(log, forProperty: "log")
    let warn = generateVariadic(context: context, name: "warn") { args in
      let args = toArrayOfValues(value: args)!
      self.backend.log(JSLogMessage(level: .warn, message: args))
      return JSValue(undefinedIn: context)
    }
    console.setValue(warn, forProperty: "warn")
    let error = generateVariadic(context: context, name: "error") { args in
      let args = toArrayOfValues(value: args)!
      self.backend.log(JSLogMessage(level: .error, message: args))
      return JSValue(undefinedIn: context)
    }
    console.setValue(error, forProperty: "error")
    context.globalObject.setValue(console, forProperty: "console")
  }
}
