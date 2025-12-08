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
