//
//  JSarrayView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import JavaScriptCore
import SwiftUI

struct JSArrayView: JSValueViewBase {
  var value: [JSValue]
  var tools: JSTools
  @State var expanded: Bool = false
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "square.stack", type: "array")
      VStack(alignment: .leading) {
        HStack {
          Text("Array (length \(value.count))")
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
          ForEach(0..<Int(value.count), id: \.self) { i in
            let item = value[i]
            HStack(alignment: .top) {
              Text("[\(i)]:").font(.system(size: 12).monospaced())
              JSValueView(value: item, tools: tools)
            }
          }.padding(.leading, 10)
        }
      }
    }
  }
}
