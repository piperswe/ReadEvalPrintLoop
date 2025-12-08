//
//  JSFunctionView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSFunctionView: JSValueViewBase {
  var name: String?
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "hammer.circle", type: "function")
      Text("Function")
      if let name = name {
        Text(name)
          .font(.system(size: 12).monospaced())
      }
    }
  }
}
