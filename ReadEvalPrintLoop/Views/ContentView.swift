//
//  ContentView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import AlertToast
import JavaScriptCore
import SwiftData
import SwiftUI

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
  @State private var toastState = ToastState()
  @State private var showAbout: Bool = false

  var body: some View {
    NavigationStack {
      ScrollViewReader { proxy in
        VStack {
          ScrollView {
            ForEach(instance.history) { item in
              HistoryItemView(
                item: item,
                runtime: instance.runtime,
                addToCode: { x in
                  scriptInput += x
                },
                latest: item.id == instance.history.last?.id
              ).id(item.id)
            }
            .padding(10)
            if processing {
              ProgressView()
            }
          }
          TextEditor(text: $scriptInput)
            .autocorrectionDisabled()
            #if os(macOS)
              .introspect(.textEditor, on: .macOS(.v13, .v14, .v15, .v26)) { nsTextView in
                nsTextView.isAutomaticQuoteSubstitutionEnabled = false
                nsTextView.isAutomaticDashSubstitutionEnabled = false
              }
            #else
              .autocapitalization(.none)
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
                  if let last = instance.history.last?.source {
                    Button("Use last", systemImage: "arrow.up") {
                      scriptInput = last
                    }
                    .labelStyle(.iconOnly)
                  }
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
            .cornerRadius(4)
            .overlay {
              RoundedRectangle(cornerRadius: 4)
                .stroke(.secondary, lineWidth: 1)
            }
            .padding(10)
        }
      }
      .navigationDestination(isPresented: $showAbout) {
        AboutView()
          .navigationTitle("About")
          .navigationBarTitleDisplayMode(.inline)
      }
      .navigationTitle("ReadEvalPrintLoop")
      .navigationSubtitle("JavaScript")
      .navigationBarTitleDisplayMode(.inline)
      #if !os(macOS)
        .toolbar {
          Button("About") {
            showAbout = true
          }
        }
      #endif
    }
    .onAppear {
      fieldFocused = true
    }
    .task {
      await instance.setupGlobals()
    }
    .environment(toastState)
    .toast(isPresenting: $toastState.showCopied) {
      AlertToast(displayMode: .hud, type: .regular, title: "Copied!")
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
