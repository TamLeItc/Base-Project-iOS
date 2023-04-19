//
//  Inject.swift
//  BaseProject
//
//  Created by Tam Le on 05/04/2023.
//

import Foundation
import Swinject

@propertyWrapper
public struct Inject<Value> {
  private(set) public var wrappedValue: Value
  
  public init() {
      self.wrappedValue = DI.shared.resolve()
  }
}

