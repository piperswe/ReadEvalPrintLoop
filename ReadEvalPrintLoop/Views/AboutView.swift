//
//  AboutView.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
//

import SwiftUI

#if !os(macOS)
  import UIKit
#endif

struct AboutView: View {
  private var appVersionAndBuild: String {
    let version =
      Bundle.main
      .infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let build =
      Bundle.main
      .infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    return "Version \(version) (\(build))"
  }

  private var copyright: String {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: Date())
    return "© \(year) Piper McCorkle"
  }

  private var developerWebsite: URL {
    URL(string: "https://piperswe.me")!
  }

  var device: String {
    #if os(macOS)
      return "Mac"
    #else
      switch UIDevice.current.userInterfaceIdiom {
      case .phone:
        return "iPhone"
      case .pad:
        return "iPad"
      case .mac:
        return "Mac"
      case .tv:
        return "Apple TV"
      case .carPlay:
        return "your car...?"
      case .vision:
        return "Apple Vision"
      case .unspecified:
        fallthrough
      @unknown default:
        return "this device"
      }
    #endif
  }

  var body: some View {
    VStack(spacing: 14) {
      Image("interim-icon")
        .resizable().scaledToFit()
        .frame(width: 80)
      Text("ReadEvalPrintLoop")
        .font(.title)
      Text("A JavaScript REPL for \(device)")
        .font(.subheadline)
      VStack(spacing: 6) {
        Text(appVersionAndBuild)
        Text(copyright)
      }
      .font(.callout)
      Link(
        "Developer Website",
        destination: developerWebsite
      )
      .foregroundStyle(Color.accentColor)
      ScrollView {
        VStack(alignment: .leading, spacing: 6) {
          Text(
            try! String(
              contentsOf: Bundle.main.url(forResource: "CREDITS", withExtension: "txt")!,
              encoding: .utf8))
          ForEach(thirdPartyLibraries) { lib in
            Text("Contains \(lib.name) \(lib.version).")
            Text(lib.license)
          }
        }
      }
    }
    .padding()
    .frame(minWidth: 400, minHeight: 600)
  }
}

#Preview {
  AboutView()
}
