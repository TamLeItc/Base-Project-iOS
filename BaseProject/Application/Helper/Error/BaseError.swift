//
//  BaseError.swift
//  BaseProject
//
//  Created by Tam Le on 26/04/2023.
//

import Foundation

protocol BaseError: Error {
    var description: String { get set }
}
