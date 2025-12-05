//
//  JSValueView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//

import SwiftUI
import JavaScriptCore

struct JSValueView: View {
    let iconSize: CGFloat = 12
    
    var value: JSValue
    var tools: JSTools
    var logMessage: Bool = false
    
    @State var expanded: Bool = false
    
    var body: some View {
        HStack {
            if value.isUndefined {
                undefinedBody
            } else if value.isNull {
                nullBody
            } else if value.isBoolean {
                booleanBody
            } else if value.isNumber {
                numberBody
            } else if value.isString {
                stringBody
            } else if value.isArray {
                arrayBody
            } else if value.isDate {
                dateBody
            } else if value.isSymbol {
                symbolBody
            } else if tools.typeof(value) == "function" {
                functionBody
            } else if value.isObject {
                objectBody
            } else {
                Text("unknown value: \(value.toString()!) (contact the REPL author - this is a bug!)")
            }
        }
    }
    
    private func icon(name: String, type: String) -> some View {
        return Image(systemName: name)
            .help("type: \(type)")
            .frame(width: iconSize)
            .font(.system(size: iconSize))
    }
    
    var undefinedBody: some View {
        HStack(alignment: .top) {
            icon(name: "questionmark.square.dashed", type: "undefined")
            Text("undefined")
        }
    }
    
    var nullBody: some View {
        HStack(alignment: .top) {
            icon(name: "questionmark.square.dashed", type: "null")
            Text("null")
        }
    }
    
    var booleanBody: some View {
        HStack(alignment: .top) {
            if value.toBool() {
                icon(name: "lightswitch.on", type: "boolean")
                Text("true")
            } else {
                icon(name: "lightswitch.off", type: "boolean")
                Text("false")
            }
        }
    }
    
    var numberBody: some View {
        HStack(alignment: .top) {
            icon(name: "numbers.rectangle", type: "number")
            Text("\(value.toDouble())")
        }
    }
    
    var stringBody: some View {
        HStack(alignment: .top) {
            if !logMessage {
                icon(name: "text.document", type: "string")
            }
            Text("\(value.toString()!)")
        }
    }
    
    var arrayBody: some View {
        HStack(alignment: .top) {
            icon(name: "square.stack", type: "array")
            VStack(alignment: .leading) {
                let length = value.forProperty("length").toInt64()
                HStack {
                    Text("Array (length \(length))")
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
                    ForEach(0..<Int(length), id: \.self) { i in
                        if let item = value.atIndex(i) {
                            HStack(alignment: .top) {
                                Text("[\(i)]:").font(.system(size: 12).monospaced())
                                JSValueView(value: item, tools: tools)
                            }
                        }
                    }.padding(.leading, 10)
                }
            }
        }
    }
    
    var dateBody: some View {
        HStack(alignment: .top) {
            icon(name: "calendar", type: "Date")
            Text("Date") // TODO: implement date
        }
    }
    
    var symbolBody: some View {
        HStack(alignment: .top) {
            icon(name: "pin.circle", type: "symbol")
            Text("Symbol()")
        }
    }
    
    var objectBody: some View {
        HStack(alignment: .top) {
            icon(name: "square.stack", type: "object")
            VStack(alignment: .leading) {
                let keys = tools.objectKeys(value)
                HStack {
                    Text("Object (\(keys.count) keys)")
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
                        if let item = value.forProperty(key) {
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
    
    var functionBody: some View {
        HStack(alignment: .top) {
            icon(name: "hammer.circle", type: "function")
            Text("Function")
            if value.hasProperty("name") {
                Text(value.forProperty("name").toString())
                    .font(.system(size: 12).monospaced())
            }
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
        JSValueView(value: JSValue(object: [
            "a": "b",
            "1": 2,
            "array time!": [1, 2, 3]
        ], in: ctx), tools: tools)
        JSValueView(value: JSValue(newObjectIn: ctx), tools: tools)
        JSValueView(value: JSValue(object: [1, 2, 3, 4], in: ctx), tools: tools)
        JSValueView(value: JSValue(object: [1, 2, 3, 4], in: ctx), tools: tools, expanded: true)
        JSValueView(value: JSValue(newSymbolFromDescription: "hi", in: ctx), tools: tools)
        JSValueView(value: ctx.evaluateScript("x => x"), tools: tools)
    }
}
