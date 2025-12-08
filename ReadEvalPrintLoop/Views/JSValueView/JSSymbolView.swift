//
//  JSSymbolView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSSymbolView: JSValueViewBase {
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "pin.circle", type: "symbol")
      Text("Symbol()")
    }
  }
}
