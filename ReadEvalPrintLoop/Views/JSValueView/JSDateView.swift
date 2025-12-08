//
//  JSDateView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSDateView: JSValueViewBase {
  var value: Date
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "calendar", type: "Date")
      Text("Date")  // TODO: implement date
    }
  }
}
