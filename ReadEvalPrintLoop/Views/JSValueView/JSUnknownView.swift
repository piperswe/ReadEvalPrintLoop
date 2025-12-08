//
//  JSUnknownView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSUnknownView: JSValueViewBase {
  var string: String
  var body: some View {
    Text(
      "unknown value: \(string) (contact the REPL author - this is a bug!)"
    )
  }
}
