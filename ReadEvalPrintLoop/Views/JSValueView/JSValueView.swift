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
  var runtime: JavaScriptRuntime
  var logMessage: Bool = false

  @State var viewable: ViewableJSValue = .loading

  var body: some View {
    Group {
      viewable.body(runtime: runtime)
    }
    .task {
      let value = value
      let runtime = runtime
      viewable = await ViewableJSValue.from(value: value, runtime: runtime)
    }
  }
}

#Preview {
  let runtime = JavaScriptRuntime()
  VStack(alignment: .leading) {
    JSValueView(value: runtime.undefined, runtime: runtime)
    JSValueView(value: runtime.null, runtime: runtime)
    JSValueView(value: runtime.jsTrue, runtime: runtime)
    JSValueView(value: runtime.jsFalse, runtime: runtime)
    JSValueView(value: runtime.number(1234.56), runtime: runtime)
    JSValueView(
      value: runtime.value([
        "a": "b",
        "1": 2,
        "array time!": [1, 2, 3],
      ], ), runtime: runtime
    )
    JSValueView(value: runtime.object(), runtime: runtime)
    JSValueView(value: runtime.array(values: [1, 2, 3, 4]), runtime: runtime)
    JSValueView(
      value: runtime.symbol(description: "hi"), runtime: runtime
    )
    //    JSValueView(value: try! runtime.evaluate(script: "x => x")!, runtime: runtime)
  }
  .frame(minWidth: 400)
}
