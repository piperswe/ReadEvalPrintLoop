//
//  JSNumberView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSNumberView: JSValueViewBase {
  var value: Double
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "numbers.rectangle", type: "number")
      Text("\(value)")
    }
  }
}
