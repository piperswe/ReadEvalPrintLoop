//
//  JavaScriptRuntime.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/8/25.
//

import JavaScriptCore

enum JavaScriptError: Error {
  case error(String)
}

actor JavaScriptRuntime {
  private let vm: JSVirtualMachine
  private nonisolated let context: JSContext

  private let jsObject: JSValue
  private let jsObjectKeys: JSValue
  private let jsTypeof: JSValue
  nonisolated let undefined: JSValue
  nonisolated let null: JSValue
  nonisolated let jsTrue: JSValue
  nonisolated let jsFalse: JSValue

  init() {
    vm = JSVirtualMachine()
    context = JSContext(virtualMachine: vm)
    jsObject = context.globalObject.forProperty("Object")
    jsObjectKeys = jsObject.forProperty("keys")
    jsTypeof = context.evaluateScript("x => typeof x")
    undefined = context.evaluateScript("void 0")
    null = context.evaluateScript("null")
    jsTrue = JSValue(bool: true, in: context)
    jsFalse = JSValue(bool: false, in: context)
  }

  func setupGlobalThis() {
    setGlobal(name: "globalThis", value: context.globalObject)
  }

  func evaluate(script: String) throws -> JSValue? {
    let retval = context.evaluateScript(script)
    if let exception = context.exception {
      context.exception = nil
      throw JavaScriptError.error(exception.toString())
    } else {
      return retval
    }
  }

  func objectKeys(_ obj: JSValue) -> [String] {
    return jsObjectKeys.call(withArguments: [obj])!.toArray()! as! [String]
  }

  func typeof(_ val: JSValue) -> String {
    return jsTypeof.call(withArguments: [val]).toString()
  }

  func function(f: @convention(block) @escaping (JSValue) -> JSValue) -> JSValue {
    return JSValue(object: f, in: context)
  }

  func function(f: @convention(block) @escaping (JSValue, JSValue) -> JSValue) -> JSValue {
    return JSValue(object: f, in: context)
  }

  func function(f: @convention(block) @escaping (JSValue, JSValue, JSValue) -> JSValue) -> JSValue {
    return JSValue(object: f, in: context)
  }

  func function(f: @convention(block) @escaping (JSValue, JSValue, JSValue, JSValue) -> JSValue)
    -> JSValue
  {
    return JSValue(object: f, in: context)
  }

  func function(
    f: @convention(block) @escaping (JSValue, JSValue, JSValue, JSValue, JSValue) -> JSValue
  ) -> JSValue {
    return JSValue(object: f, in: context)
  }

  func variadicFunction(
    name: String? = nil, f: @convention(block) @escaping (JSValue) -> JSValue
  ) -> JSValue {
    let generator = context.evaluateScript(
      "f => function \(name ?? "")(...args) { return f(args); }")!
    if context.exception != nil {
      fatalError("exception evaluating generator: \(context.exception.toString()!)")
    }
    let generated = generator.call(withArguments: [f])!
    if context.exception != nil {
      fatalError("exception calling generator: \(context.exception.toString()!)")
    }
    return generated
  }

  func setGlobal(name: String, value: Any?) {
    context.globalObject.setValue(value, forProperty: name)
  }

  nonisolated func object() -> JSValue {
    return JSValue(newObjectIn: context)
  }

  nonisolated func object(values: [String: Any?]) -> JSValue {
    return value(values)
  }

  nonisolated func array() -> JSValue {
    return JSValue(newArrayIn: context)
  }

  nonisolated func array(values: [Any?]) -> JSValue {
    return value(values)
  }

  nonisolated func string(_ str: String) -> JSValue {
    return JSValue(object: str, in: context)
  }

  nonisolated func number(_ double: Double) -> JSValue {
    return JSValue(double: double, in: context)
  }

  nonisolated func bool(_ bool: Bool) -> JSValue {
    if bool {
      return jsTrue
    } else {
      return jsFalse
    }
  }

  nonisolated func value(_ val: Any?) -> JSValue {
    return JSValue(object: val, in: context)
  }

  nonisolated func symbol(description: String = "") -> JSValue {
    return JSValue(newSymbolFromDescription: description, in: context)
  }
}
