//
//  ViewableJSValue.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import JavaScriptCore
import SwiftUI

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

  nonisolated static func from(value: JSValue, runtime: JavaScriptRuntime) async -> ViewableJSValue
  {
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
    } else if await runtime.typeof(value) == "function" {
      let name = value.forProperty("name")?.toString()
      return .function(name: name)
    } else if value.isObject {
      let keys = await runtime.objectKeys(value)
      var values: [String: JSValue] = [:]
      for k in keys {
        values[k] = value.forProperty(k)
      }
      return .object(values: values)
    } else {
      return .unknown(string: value.toString())
    }
  }

  func body(runtime: JavaScriptRuntime) -> some View {
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
        JSArrayView(value: values, runtime: runtime)
      case .date(let value):
        JSDateView(value: value)
      case .symbol:
        JSSymbolView()
      case .function(let name):
        JSFunctionView(name: name)
      case .object(let values):
        JSObjectView(values: values, runtime: runtime)
      case .unknown(let string):
        JSUnknownView(string: string)
      case .loading:
        JSLoadingView()
      }
    }
  }
}
