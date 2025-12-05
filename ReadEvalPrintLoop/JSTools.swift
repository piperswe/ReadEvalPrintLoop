//
//  JSTools.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//

import Foundation
import JavaScriptCore

func toArrayOfValues(value: JSValue) -> [JSValue]? {
    if !value.isArray {
        return nil
    }
    
    let len = value.forProperty("length").toInt64()
    return (0..<len).map { i in value.atIndex(Int(i)) }
}

class JSTools {
    var context: JSContext
    
    private var jsObject: JSValue
    private var jsObjectKeys: JSValue
    private var jsTypeof: JSValue
    
    init(context: JSContext) {
        self.context = context
        jsObject = context.globalObject.forProperty("Object")
        jsObjectKeys = jsObject.forProperty("keys")
        jsTypeof = context.evaluateScript("x => typeof x")
    }
    
    func objectKeys(_ obj: JSValue) -> [String] {
        return jsObjectKeys.call(withArguments: [obj])!.toArray()! as! [String]
    }
    
    func typeof(_ val: JSValue) -> String {
        return jsTypeof.call(withArguments: [val]).toString()
    }
}
