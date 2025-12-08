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

struct JSUndefinedView: JSValueViewBase {
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "questionmark.square.dashed", type: "undefined")
      Text("undefined")
    }
  }
}

struct JSNullView: JSValueViewBase {
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "questionmark.square.dashed", type: "null")
      Text("null")
    }
  }
}

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

struct JSNumberView: JSValueViewBase {
  var value: Double
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "numbers.rectangle", type: "number")
      Text("\(value)")
    }
  }
}

struct JSStringView: JSValueViewBase {
  var value: String
  var logMessage: Bool = false
  var body: some View {
    HStack(alignment: .top) {
      if !logMessage {
        icon(name: "text.document", type: "string")
      }
      Text("\(value)")
    }
  }
}

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

struct JSDateView: JSValueViewBase {
  var value: Date
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "calendar", type: "Date")
      Text("Date")  // TODO: implement date
    }
  }
}

struct JSSymbolView: JSValueViewBase {
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "pin.circle", type: "symbol")
      Text("Symbol()")
    }
  }
}

struct JSFunctionView: JSValueViewBase {
  var name: String?
  var body: some View {
    HStack(alignment: .top) {
      icon(name: "hammer.circle", type: "function")
      Text("Function")
      if let name = name {
        Text(name)
          .font(.system(size: 12).monospaced())
      }
    }
  }
}

struct JSObjectView: JSValueViewBase {
  var values: [String: JSValue]
  var tools: JSTools
  @State var expanded: Bool = false
  private var keys: [String]

  init(values: [String: JSValue], tools: JSTools) {
    self.values = values
    self.tools = tools
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
                JSValueView(value: item, tools: tools)
              }
            }
          }.padding(.leading, 10)
        }
      }
    }
  }
}

struct JSUnknownView: JSValueViewBase {
  var string: String
  var body: some View {
    Text(
      "unknown value: \(string) (contact the REPL author - this is a bug!)"
    )
  }
}

struct JSLoadingView: JSValueViewBase {
  var body: some View {
    Text(
      "loading..."
    )
  }
}

enum ViewableJSValue {
  case undefined
  case null
  case boolean(value: Bool)
  case number(value: Double)
  case string(value: String)
  case array(values: [JSValue])
  case date(value: Date)
  case symbol
  case function(name: String?)
  case object(values: [String: JSValue])
  case unknown(string: String)

  case loading

  static func from(value: JSValue, tools: JSTools) -> ViewableJSValue {
    if value.isUndefined {
      return .undefined
    } else if value.isNull {
      return .null
    } else if value.isBoolean {
      return .boolean(value: value.toBool())
    } else if value.isNumber {
      return .number(value: value.toDouble())
    } else if value.isString {
      return .string(value: value.toString())
    } else if value.isArray {
      var arr: [JSValue] = []
      let length = value.forProperty("length").toInt64()
      for i in 0..<length {
        arr.append(value.atIndex(Int(i)))
      }
      return .array(values: arr)
    } else if value.isDate {
      return .date(value: Date(timeIntervalSince1970: TimeInterval(value.toInt64())))
    } else if value.isSymbol {
      return .symbol
    } else if tools.typeof(value) == "function" {
      let name = value.forProperty("name")?.toString()
      return .function(name: name)
    } else if value.isObject {
      let keys = tools.objectKeys(value)
      var values: [String: JSValue] = [:]
      for k in keys {
        values[k] = value.forProperty(k)
      }
      return .object(values: values)
    } else {
      return .unknown(string: value.toString())
    }
  }

  func body(tools: JSTools) -> some View {
    Group {
      switch self {
      case .undefined:
        JSUndefinedView()
      case .null:
        JSNullView()
      case .boolean(let value):
        JSBooleanView(value: value)
      case .number(let value):
        JSNumberView(value: value)
      case .string(let value):
        JSStringView(value: value)
      case .array(let values):
        JSArrayView(value: values, tools: tools)
      case .date(let value):
        JSDateView(value: value)
      case .symbol:
        JSSymbolView()
      case .function(let name):
        JSFunctionView(name: name)
      case .object(let values):
        JSObjectView(values: values, tools: tools)
      case .unknown(let string):
        JSUnknownView(string: string)
      case .loading:
        JSLoadingView()
      }
    }
  }
}

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
      viewable = ViewableJSValue.from(value: value, tools: tools)
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
