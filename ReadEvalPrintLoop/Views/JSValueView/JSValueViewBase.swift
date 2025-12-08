//
//  JSValueViewBase.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

protocol JSValueViewBase: View {}

extension JSValueViewBase {
  var iconSize: CGFloat { return 12 }
  func icon(name: String, type: String) -> some View {
    return Image(systemName: name)
      .help("type: \(type)")
      .frame(width: iconSize)
      .font(.system(size: iconSize))
  }
}
