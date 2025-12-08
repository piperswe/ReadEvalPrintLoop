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

  func attach(runtime: JavaScriptRuntime) async {
    let consoleFields = [
      "log": await runtime.variadicFunction(name: "log") { args in
        let args = toArrayOfValues(value: args)!
        self.backend.log(JSLogMessage(level: .log, message: args))
        return runtime.undefined
      },
      "warn": await runtime.variadicFunction(name: "warn") { args in
        let args = toArrayOfValues(value: args)!
        self.backend.log(JSLogMessage(level: .warn, message: args))
        return runtime.undefined
      },
      "error": await runtime.variadicFunction(name: "error") { args in
        let args = toArrayOfValues(value: args)!
        self.backend.log(JSLogMessage(level: .error, message: args))
        return runtime.undefined
      },
    ]
    let console = runtime.object(values: consoleFields)
    await runtime.setGlobal(name: "console", value: console)
  }
}
