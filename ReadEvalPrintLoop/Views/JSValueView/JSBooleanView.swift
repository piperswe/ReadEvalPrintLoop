//
//  JSBooleanView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

struct JSBooleanView: JSValueViewBase {
  var value: Bool
  var body: some View {
    HStack(alignment: .top) {
      if value {
        icon(name: "lightswitch.on", type: "boolean")
        Text("true")
      } else {
        icon(name: "lightswitch.off", type: "boolean")
        Text("false")
      }
    }
  }
}
