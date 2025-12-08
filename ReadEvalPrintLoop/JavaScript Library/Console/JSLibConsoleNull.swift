//
//  JSLibConsoleNull.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation

class JSLibConsoleNull: JSLibConsoleBackend {
  func log(_ message: JSLogMessage) {
    let _ = message
  }
}
