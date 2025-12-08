//
//  JSLogMessage.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore

struct JSLogMessage: Identifiable {
  var id: UUID = UUID()
  var level: JSLogLevel
  var message: [JSValue]
}
