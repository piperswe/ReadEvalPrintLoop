//
//  ContentView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI
import SwiftData
import JavaScriptCore
#if os(macOS)
import SwiftUIIntrospect
#endif

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
    
    var instance: REPLInstance
    
    @State private var scriptInput: String = ""
    @State private var processing: Bool = false
    @FocusState private var fieldFocused: Bool

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    ForEach(instance.history) { item in
                        HistoryItemView(
                            item: item,
                            tools: instance.tools,
                            addToCode: { x in
                                scriptInput += x
                            },
                            latest: item.id == instance.history.last?.id
                        ).id(item.id)
                    }
                    .padding(10)
                }
                TextEditor(text: $scriptInput)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    #if os(macOS)
                    .introspect(.textEditor, on: .macOS(.v13, .v14, .v15, .v26)) { nsTextView in
                        nsTextView.isAutomaticQuoteSubstitutionEnabled = false
                        nsTextView.isAutomaticDashSubstitutionEnabled = false
                    }
                    #else
                    .keyboardType(.asciiCapable)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Button("Run", systemImage: "play.fill") {
                                onSubmit(proxy: proxy)
                            }
                            .labelStyle(.iconOnly)
                            Button("Clear", systemImage: "clear") {
                                scriptInput = ""
                            }
                            .labelStyle(.iconOnly)
                            Button("Use last", systemImage: "arrow.up") {
                                if let last = instance.history.last?.sourceStr {
                                    scriptInput = last
                                }
                            }
                            .labelStyle(.iconOnly)
                            .disabled(instance.history.isEmpty)
                        }
                    }
                    #endif
                    .onKeyPress(keys: [.return]) { press in
                        if press.modifiers.contains(.shift) {
                            onSubmit(proxy: proxy)
                            return .handled
                        } else {
                            return .ignored
                        }
                    }
                    .onSubmit { onSubmit(proxy: proxy) }
                    .focused($fieldFocused)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 30, maxHeight: 200)
                    .border(.secondary)
                    .padding(10)
            }
        }
        .onAppear {
            fieldFocused = true
        }
    }
    
    private func onSubmit(proxy: ScrollViewProxy) {
        let script = scriptInput
        if script.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            scriptInput = ""
            processing = true
            Task {
                let _ = await instance.evaluate(source: script)
                // add to the dispatch queue to give the UI time to react to the instance being changed
                DispatchQueue.main.async {
                    proxy.scrollTo(instance.lastResultId, anchor: .bottom)
                    processing = false
                    fieldFocused = true
                }
            }
        }
    }
}

#Preview {
    ContentView(instance: REPLInstance())
//        .modelContainer(for: Item.self, inMemory: true)
}
