//
//  ScopeFunc.swift
//  BaseProject
//
//  Created by Tam Le on 10/22/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

/// Scope functions
protocol ScopeFunc { }

extension ScopeFunc {
  /// Calls the specified function block with self value as its argument and returns self value.
  @inline(__always) func apply(block: (Self) -> ()) -> Self {
    block(self)
    return self
  }

  /// Calls the specified function block with self value as its argument and returns its result.
  @discardableResult
  @inline(__always) func letIt<R>(block: (Self) -> R) -> R {
    return block(self)
  }
}

extension NSObject: ScopeFunc { }
