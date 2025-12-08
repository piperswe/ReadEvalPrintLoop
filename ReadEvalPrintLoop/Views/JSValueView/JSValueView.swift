//
//  JSValueView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import JavaScriptCore
import SwiftUI

struct JSValueView: View {
  var value: JSValue
  var tools: JSTools
  var logMessage: Bool = false

  @State var viewable: ViewableJSValue = .loading

  var body: some View {
    Group {
      viewable.body(tools: tools)
    }
    .task {
      let value = value
      let tools = tools
      viewable = await Task.detached(
        name: "rendering JavaScript value",
        priority: .userInitiated
      ) {
        return ViewableJSValue.from(value: value, tools: tools)
      }.value
    }
  }
}

#Preview {
  let ctx = JSContext()!
  let tools = JSTools(context: ctx)
  VStack(alignment: .leading) {
    JSValueView(value: JSValue(undefinedIn: ctx), tools: tools)
    JSValueView(value: JSValue(nullIn: ctx), tools: tools)
    JSValueView(value: JSValue(bool: true, in: ctx), tools: tools)
    JSValueView(value: JSValue(bool: false, in: ctx), tools: tools)
    JSValueView(value: JSValue(double: 1234.56, in: ctx), tools: tools)
    JSValueView(
      value: JSValue(
        object: [
          "a": "b",
          "1": 2,
          "array time!": [1, 2, 3],
        ],
        in: ctx
      ),
      tools: tools
    )
    JSValueView(value: JSValue(newObjectIn: ctx), tools: tools)
    JSValueView(value: JSValue(object: [1, 2, 3, 4], in: ctx), tools: tools)
    JSValueView(
      value: JSValue(object: [1, 2, 3, 4], in: ctx),
      tools: tools
    )
    JSValueView(
      value: JSValue(newSymbolFromDescription: "hi", in: ctx),
      tools: tools
    )
    JSValueView(value: ctx.evaluateScript("x => x"), tools: tools)
  }
  .frame(minWidth: 400)
}
