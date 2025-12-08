//
//  SwiftUIView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI
import JavaScriptCore

struct HistoryItemView: View {
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    var item: HistoryItem
    var tools: JSTools
    var addToCode: ((String) -> ())?
    var latest: Bool
    
    @State var highlightedSource: AttributedString
    
    init(item: HistoryItem, tools: JSTools, addToCode: ((String) -> Void)? = nil, latest: Bool = true) {
        self.item = item
        self.tools = tools
        self.addToCode = addToCode
        self.latest = latest
        self.highlightedSource = AttributedString(item.source)
    }
    
    var body: some View {
        let body = HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(sourceAttributedString)
                    .font(.system(.body, design: .monospaced))
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
                            JSValueView(value: message, tools: tools, logMessage: true)
                        }
                    }
                }
                if let exception = item.exception {
                    Text(exception).foregroundColor(.red)
                } else if let result = item.result {
                    JSValueView(value: result, tools: tools)
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
            .task(id: colorScheme) {
                self.highlightedSource = await highlightJavaScript(item.source, colorScheme: colorScheme)
            }
        if latest {
            body
        } else {
            body.foregroundStyle(.secondary)
        }
    }
    
    private var sourceAttributedString: AttributedString {
        var prompt = AttributedString("> ")
        prompt.foregroundColor = .secondary
        return prompt + highlightedSource
    }
}

#Preview {
    let ctx = JSContext()!
    let tools = JSTools(context: ctx)
    ScrollView {
        HistoryItemView(
            item: HistoryItem(
                source: "1+1",
                logs: [
                    JSLogMessage(level: .log, message: [
                        JSValue(object: "hello world", in: ctx),
                        JSValue(object: [1, 2, 3], in: ctx)
                    ])
                ],
                result: JSValue(double: 1234.5678, in: ctx),
                resultIndex: 4,
            ),
            tools: tools
        )
    }
}
