//
//  PermissionDelegate.swift
//  BaseProject
//
//  Created by Tam Le on 31/03/2023.
//

import Foundation

protocol PermissionHelperDelegate {
    func allowed(_ item: Permission)
    func denied(_ item: Permission)
}
