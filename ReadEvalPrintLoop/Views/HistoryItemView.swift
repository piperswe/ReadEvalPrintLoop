//
//  SwiftUIView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import JavaScriptCore
import SwiftUI

struct HistoryItemView: View {
  @Environment(\.colorScheme) private var colorScheme: ColorScheme
  var item: HistoryItem
  var runtime: JavaScriptRuntime
  var addToCode: ((String) -> Void)?
  var latest: Bool = true

  var body: some View {
    let body = HStack(alignment: .center) {
      VStack(alignment: .leading) {
        SyntaxHighlightedTextView(source: item.source, prefix: HistoryItemView.prefix)
        ForEach(item.logs) { log in
          HStack {
            switch log.level {
            case .log:
              Text("log:").foregroundStyle(.blue)
            case .warn:
              Text("warn:").foregroundStyle(.yellow)
            case .error:
              Text("error:").foregroundStyle(.red)
            }
            ForEach(log.message, id: \.hash) { message in
              JSValueView(
                value: message,
                runtime: runtime,
                logMessage: true
              )
            }
          }
        }
        if let exception = item.exception {
          Text(exception).foregroundColor(.red)
        } else if let result = item.result {
          JSValueView(value: result, runtime: runtime)
        }
      }
      Spacer()
      if let resultIndex = item.resultIndex {
        Text("results[\(resultIndex)]")
          .font(.system(.body, design: .monospaced))
          .foregroundStyle(.secondary)
          .onTapGesture {
            if let addToCode = self.addToCode {
              addToCode("results[\(resultIndex)]")
            }
          }
      }
    }
    if latest {
      body
    } else {
      body.foregroundStyle(.secondary)
    }
  }

  private static var prefix: AttributedString = {
    var prompt = AttributedString("> ")
    prompt.foregroundColor = .secondary
    return prompt
  }()
}

#Preview {
  let runtime = JavaScriptRuntime()
  ScrollView {
    HistoryItemView(
      item: HistoryItem(
        source: "1+1",
        logs: [
          JSLogMessage(
            level: .log,
            message: [
              runtime.string("hello world"),
              runtime.array(values: [1, 2, 3]),
            ]
          )
        ],
        result: runtime.number(1234.5678),
        resultIndex: 4,
      ),
      runtime: runtime
    )
  }
}
