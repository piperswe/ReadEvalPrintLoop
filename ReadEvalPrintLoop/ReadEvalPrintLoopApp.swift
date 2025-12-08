//
//  ReadEvalPrintLoopApp.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftData
import SwiftUI

@main
struct ReadEvalPrintLoopApp: App {
  //    var sharedModelContainer: ModelContainer = {
  //        let schema = Schema([
  //            Item.self,
  //        ])
  //        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
  //
  //        do {
  //            return try ModelContainer(for: schema, configurations: [modelConfiguration])
  //        } catch {
  //            fatalError("Could not create ModelContainer: \(error)")
  //        }
  //    }()

  @Environment(\.openWindow) private var openWindow

  var instance = REPLInstance()

  var body: some Scene {
    WindowGroup {
      ContentView(instance: instance)
    }
    #if os(macOS)
      .commands {
        CommandGroup(replacing: CommandGroupPlacement.appInfo) {
          Button {
            openWindow(id: "about")
          } label: {
            Text("About ReadEvalPrintLoop")
          }
        }
      }
    #endif

    #if os(macOS)
      Window("About ReadEvalPrintLoop", id: "about") {
        AboutView()
          .windowResizeBehavior(.disabled)
          .windowMinimizeBehavior(.disabled)
      }
      .defaultSize(width: 400, height: 400)
      .windowResizability(.contentSize)
    //        .modelContainer(sharedModelContainer)
    #endif
  }
}
