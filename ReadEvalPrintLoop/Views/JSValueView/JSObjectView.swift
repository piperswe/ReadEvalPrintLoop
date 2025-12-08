//
//  JSObjectView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import JavaScriptCore
import SwiftUI

struct JSObjectView: JSValueViewBase {
  var values: [String: JSValue]
  var runtime: JavaScriptRuntime
  @State var expanded: Bool = false
  private var keys: [String]

  init(values: [String: JSValue], runtime: JavaScriptRuntime) {
    self.values = values
    self.runtime = runtime
    keys = values.keys.sorted()
  }

  var body: some View {
    HStack(alignment: .top) {
      icon(name: "square.stack", type: "object")
      VStack(alignment: .leading) {
        HStack {
          Text("Object (\(values.count) keys)")
          if expanded {
            Image(systemName: "eye")
              .help("Click to hide details")
              .onTapGesture {
                expanded = false
              }
          } else {
            Image(systemName: "eye.slash")
              .help("Click to show details")
              .onTapGesture {
                expanded = true
              }
          }
        }
        if expanded {
          ForEach(keys, id: \.self) { key in
            if let item = values[key] {
              HStack(alignment: .top) {
                Text("\(key):").font(.system(size: 12).monospaced())
                JSValueView(value: item, runtime: runtime)
              }
            }
          }.padding(.leading, 10)
        }
      }
    }
  }
}
