//
//  PermissionManager.swift
//  BaseProject
//
//  Created by Tam Le on 31/03/2023.
//

import Foundation
import Photos
import CoreLocation
import CoreBluetooth
import UIKit
import Contacts
import ContactsUI

class PermissionHelper: NSObject {
    
    static let shared = PermissionHelper()
    
    var delegate: PermissionHelperDelegate? = nil
    
    private var permission: Permission = .photo
    
    private var centralManager: CBCentralManager? = nil
    private var locationManager: CLLocationManager? = nil
    
    func checkPermission(_ permission: Permission) -> Bool {
        switch permission {
        case .photo:
            return checkPhotoPermission()
        case .contact:
            return checkPhotoPermission()
        default:
            return false
        }
    }
    
    func requestPermission(parentVC: UIViewController, permission: Permission, delegate: PermissionHelperDelegate) {
        self.delegate = delegate
        self.permission = permission
        
        DispatchQueue.main.async {
            switch permission {
            case .photo:
                PHPhotoLibrary.requestAuthorization({ status in
                    switch status {
                    case .authorized, .limited:
                        self.delegate?.allowed(permission)
                    default:
                        self.delegate?.denied(permission)
                        self.showDialogRequirePermission(parentVC, permission: permission)
                    }
                })
            case .contact:
                let enti = CNEntityType.contacts
                let contactStore = CNContactStore.init()
                contactStore.requestAccess(for: enti) { [weak self] (success, nil) in
                    guard let self = self else { return }
                    if success {
                        self.delegate?.allowed(.contact)
                    } else {
                        self.delegate?.denied(.contact)
                    }
                }
            default:
                break
            }
        }
    }
    
    func showDialogRequirePermission(_ parentVC: UIViewController, permission: Permission) {
        
        var title = ""
        var message = ""
        DispatchQueue.main.async {
            switch permission {
            case .photo:
                title = "library_permission_is_not_granted_title".localized
                message = "library_permission_is_not_granted_message".localized
            case .camera:
                title = "camera_permission_is_not_granted_title".localized
                message = "camera_permission_is_not_granted_message".localized
            case .contact:
                title = "contact_permission_is_not_granted_title".localized
                message = "contact_permission_is_not_granted_message".localized
            }
        }
        
        let alert = AlertVC(title: title, message: message, style: .alert)
        alert.addAction(AlertAction(title: "cancel".localized, style: .cancel))
        alert.addAction(AlertAction(title: "settings".localized, style: .confirm, onClick: {_ in
            AppUtils.goToAppSettings()
        }))
        parentVC.presentVC(alert)
    }
    
    private func checkPhotoPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    private func checkContactPermission() -> Bool {
        let enti = CNEntityType.contacts
        return CNContactStore.authorizationStatus(for: enti) == .authorized
    }
}
