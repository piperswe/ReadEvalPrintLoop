//
//  JSStringView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSStringView: JSValueViewBase {
  var value: String
  var logMessage: Bool = false
  var body: some View {
    HStack(alignment: .top) {
      if !logMessage {
        icon(name: "text.document", type: "string")
      }
      Text("\(value)")
    }
  }
}
