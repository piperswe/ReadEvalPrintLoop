//
//  JSLibConsoleStore.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation

class JSLibConsoleStore: JSLibConsoleBackend {
  var messages: [JSLogMessage] = []

  func log(_ message: JSLogMessage) {
    messages.append(message)
  }
}
