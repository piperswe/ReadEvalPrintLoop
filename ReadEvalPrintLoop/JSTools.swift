//
//  JSTools.swift
//  ReadEvalPrintLoop
//
//  Created by Piper McCorkle on 12/4/25.
//
//  Copyright (c) 2025 Piper McCorkle.
//  All rights reserved.
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
