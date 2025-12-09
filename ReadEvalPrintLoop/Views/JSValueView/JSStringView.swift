//
//  JSStringView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import AlertToast
import SwiftUI

#if os(macOS)
  import AppKit
#else
  import UIKit
#endif

struct JSStringView: JSValueViewBase {
  var value: String
  var logMessage: Bool = false
  @State var showToast: Bool = false
  var body: some View {
    HStack(alignment: .top) {
      if !logMessage {
        icon(name: "text.document", type: "string")
      }
      Text("\(value)")
      Button("Copy", systemImage: "document.on.document") {
        #if os(macOS)
          let pasteboard = NSPasteboard.general
          pasteboard.setString(value, forType: .string)
        #else
          let pasteboard = UIPasteboard.general
          pasteboard.clearContents()
          pasteboard.writeObjects([value as NSString])
        #endif
        showToast = true
      }.controlSize(.mini)
    }
    .toast(isPresenting: $showToast) {
      AlertToast(displayMode: .hud, type: .regular, title: "Copied!")
    }
  }
}
