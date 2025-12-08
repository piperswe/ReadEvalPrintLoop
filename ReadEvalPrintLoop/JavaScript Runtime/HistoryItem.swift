//
//  HistoryItem.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/7/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import Foundation
import JavaScriptCore

struct HistoryItem: Identifiable {
  var id: UUID = UUID()
  var source: String
  var logs: [JSLogMessage] = []
  var result: JSValue?
  var exception: String?
  var resultIndex: Int?
}
