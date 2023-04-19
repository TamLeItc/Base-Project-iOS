//
//  UIDevice.swift
//  BaseProject
//
//  Created by Tam Le on 8/20/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var safeArea: UIEdgeInsets {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            if window != nil {
                return window!.safeAreaInsets
            }
        } else if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            if window != nil {
                return window!.safeAreaInsets
            }
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    static var model: DevideModel {
        let screenHeight = UIScreen.main.nativeBounds.height
        if isPhone {
            switch screenHeight {
            case 1136:
                return .iphone_5_5S_5C
            case 1334:
                return .iphone_6_6Plus_6S_7_8
            case 2208:
                return .iphone_6SPlus_7Plus_8Plus
            case 2340:
                return .iphone_12Mini_13Mini
            case 2436:
                return .iphone_X_XS_11Pro
            case 1792:
                return .iphone_XR_11
            case 2532:
                return .iphone_12_12Pro_13_13Pro_14
            case 2688:
                return .iphone_XSMax_11ProMax
            case 2778:
                return .iphone_12ProMax_13ProMax_14Plus
            default:
                return .iphone_12ProMax_13ProMax_14Plus
            }
        } else {
            switch screenHeight {
            case 1024:
                return .ipad_9Point7InSmall
            case 2048:
                return .ipad_9Point7InLarge
            case 2160:
                return .ipad_10Point2In
            case 2224:
                return .ipad_10Point5In
            case 2388:
                return .ipad_11In
            case 2732:
                return .ipad_12Point9In
            default:
                return .ipad_10Point2In
            }
        }
        
    }
}

extension UIDevice {
    static let device: DeviceName = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> DeviceName { // swiftlint:disable:this cyclomatic_complexity
            switch identifier {
            case "iPhone5,1", "iPhone5,2":                        return .iphone5
            case "iPhone5,3", "iPhone5,4":                        return .iphone5C
            case "iPhone6,1", "iPhone6,2":                        return .iphone5S
            case "iPhone7,2":                                     return .iphone6
            case "iPhone7,1":                                     return .iphone6Plus
            case "iPhone8,1":                                     return .iphone6s
            case "iPhone8,2":                                     return .iphone6sPlus
            case "iPhone9,1", "iPhone9,3":                        return .iphone7
            case "iPhone9,2", "iPhone9,4":                        return .iphone7Plus
            case "iPhone10,1", "iPhone10,4":                      return .iphone8
            case "iPhone10,2", "iPhone10,5":                      return .iphone8Plus
            case "iPhone10,3", "iPhone10,6":                      return .iphoneX
            case "iPhone11,2":                                    return .iphoneXS
            case "iPhone11,4", "iPhone11,6":                      return .iphoneXSMax
            case "iPhone11,8":                                    return .iphoneXR
            case "iPhone12,1":                                    return .iphone11
            case "iPhone12,3":                                    return .iphone11Pro
            case "iPhone12,5":                                    return .iphone11ProMax
            case "iPhone13,1":                                    return .iphone12Mini
            case "iPhone13,2":                                    return .iphone12
            case "iPhone13,3":                                    return .iphone12Pro
            case "iPhone13,4":                                    return .iphone12ProMax
            case "iPhone14,4":                                    return .iphone13Mini
            case "iPhone14,5":                                    return .iphone13
            case "iPhone14,2":                                    return .iphone13Pro
            case "iPhone14,3":                                    return .iphone13ProMax
            case "iPhone14,7":                                    return .iphone14
            case "iPhone14,8":                                    return .iphone14Plus
            case "iPhone15,2":                                    return .iphone14Pro
            case "iPhone15,3":                                    return .iphone14ProMax
            case "iPhone8,4":                                     return .iphoneSE
            case "iPhone12,8":                                    return .iphoneSE2
            case "iPhone14,6":                                    return .iphoneSE3
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return .ipad2
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return .ipad3
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return .ipad4
            case "iPad6,11", "iPad6,12":                          return .ipad5
            case "iPad7,5", "iPad7,6":                            return .ipad6
            case "iPad7,11", "iPad7,12":                          return .ipad7
            case "iPad11,6", "iPad11,7":                          return .ipad8
            case "iPad12,1", "iPad12,2":                          return .ipad9
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return .ipadAir
            case "iPad5,3", "iPad5,4":                            return .ipadAir2
            case "iPad11,3", "iPad11,4":                          return .ipadAir3
            case "iPad13,1", "iPad13,2":                          return .ipadAir4
            case "iPad13,16", "iPad13,17":                        return .ipadAir5
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return .ipadMini
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return .ipadMini2
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return .ipadMini3
            case "iPad5,1", "iPad5,2":                            return .ipadMini4
            case "iPad11,1", "iPad11,2":                          return .ipadMini5
            case "iPad14,1", "iPad14,2":                          return .ipadMini6
            case "iPad6,3", "iPad6,4":                            return .ipadPro9inch7
            case "iPad7,3", "iPad7,4":                            return .ipadPro10inch5
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return .ipadPro11inch
            case "iPad8,9", "iPad8,10":                           return .ipadPro11inch2nd
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return .ipadPro11inch3rd
            case "iPad6,7", "iPad6,8":                            return .ipadPro12inch9
            case "iPad7,1", "iPad7,2":                            return .ipadPro12inch92nd
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return .ipadPro12inch93rd
            case "iPad8,11", "iPad8,12":                          return .ipadPro12inch94th
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return .ipadPro12inch95th
            default: return .other
            }
        }
        
        return mapToDevice(identifier: identifier)
    }()
}

enum DeviceName: Int {
    case iphone5
    case iphone5C
    case iphone5S
    case iphone6
    case iphone6Plus
    case iphone6s
    case iphone6sPlus
    case iphone7
    case iphone7Plus
    case iphone8
    case iphone8Plus
    case iphoneX
    case iphoneXS
    case iphoneXSMax
    case iphoneXR
    case iphone11
    case iphone11Pro
    case iphone11ProMax
    case iphone12Mini
    case iphone12
    case iphone12Pro
    case iphone12ProMax
    case iphone13Mini
    case iphone13
    case iphone13Pro
    case iphone13ProMax
    case iphone14
    case iphone14Plus
    case iphone14Pro
    case iphone14ProMax
    case iphoneSE
    case iphoneSE2
    case iphoneSE3
    case ipad2
    case ipad3
    case ipad4
    case ipad5
    case ipad6
    case ipad7
    case ipad8
    case ipad9
    case ipadAir
    case ipadAir2
    case ipadAir3
    case ipadAir4
    case ipadAir5
    case ipadMini
    case ipadMini2
    case ipadMini3
    case ipadMini4
    case ipadMini5
    case ipadMini6
    case ipadPro9inch7
    case ipadPro10inch5
    case ipadPro11inch
    case ipadPro11inch2nd
    case ipadPro11inch3rd
    case ipadPro12inch9
    case ipadPro12inch92nd
    case ipadPro12inch93rd
    case ipadPro12inch94th
    case ipadPro12inch95th
    case other
    
    var name: String {
        switch self {
        case .iphone5:                  return "iPhone 5"
        case .iphone5C:                 return "iPhone 5c"
        case .iphone5S:                 return "iPhone 5s"
        case .iphone6:                  return "iPhone 6"
        case .iphone6Plus:              return "iPhone 6 Plus"
        case .iphone6s:                 return "iPhone 6s"
        case .iphone6sPlus:             return "iPhone 6s Plus"
        case .iphone7:                  return "iPhone 7"
        case .iphone7Plus:              return "iPhone 7 Plus"
        case .iphone8:                  return "iPhone 8"
        case .iphone8Plus:              return "iPhone 8 Plus"
        case .iphoneX:                  return "iPhone X"
        case .iphoneXS:                 return "iPhone XS"
        case .iphoneXSMax:              return "iPhone XS Max"
        case .iphoneXR:                 return "iPhone XR"
        case .iphone11:                 return "iPhone 11"
        case .iphone11Pro:              return "iPhone 11 Pro"
        case .iphone11ProMax:           return "iPhone 11 Pro Max"
        case .iphone12Mini:             return "iPhone 12 mini"
        case .iphone12:                 return "iPhone 12"
        case .iphone12Pro:              return "iPhone 12 Pro"
        case .iphone12ProMax:           return "iPhone 12 Pro Max"
        case .iphone13Mini:             return "iPhone 13 mini"
        case .iphone13:                 return "iPhone 13"
        case .iphone13Pro:              return "iPhone 13 Pro"
        case .iphone13ProMax:           return "iPhone 13 Pro Max"
        case .iphone14:                 return "iPhone 14"
        case .iphone14Plus:             return "iPhone 14 Plus"
        case .iphone14Pro:              return "iPhone 14 Pro"
        case .iphone14ProMax:           return "iPhone 14 Pro Max"
        case .iphoneSE:                 return "iPhone SE"
        case .iphoneSE2:                return "iPhone SE (2nd generation)"
        case .iphoneSE3:                return "iPhone SE (3rd generation)"
        case .ipad2:                    return "iPad 2"
        case .ipad3:                    return "iPad (3rd generation)"
        case .ipad4:                    return "iPad (4th generation)"
        case .ipad5:                    return "iPad (5th generation)"
        case .ipad6:                    return "iPad (6th generation)"
        case .ipad7:                    return "iPad (7th generation)"
        case .ipad8:                    return "iPad (8th generation)"
        case .ipad9:                    return "iPad (9th generation)"
        case .ipadAir:                  return "iPad Air"
        case .ipadAir2:                 return "iPad Air 2"
        case .ipadAir3:                 return "iPad Air (3rd generation)"
        case .ipadAir4:                 return "iPad Air (4th generation)"
        case .ipadAir5:                 return "iPad Air (5th generation)"
        case .ipadMini:                 return "iPad mini"
        case .ipadMini2:                return "iPad mini 2"
        case .ipadMini3:                return "iPad mini 3"
        case .ipadMini4:                return "iPad mini 4"
        case .ipadMini5:                return "iPad mini (5th generation)"
        case .ipadMini6:                return "iPad mini (6th generation)"
        case .ipadPro9inch7:            return "iPad Pro (9.7-inch)"
        case .ipadPro10inch5:           return "iPad Pro (10.5-inch)"
        case .ipadPro11inch:            return "iPad Pro (11-inch) (1st generation)"
        case .ipadPro11inch2nd:         return "iPad Pro (11-inch) (2nd generation)"
        case .ipadPro11inch3rd:         return "iPad Pro (11-inch) (3rd generation)"
        case .ipadPro12inch9:           return "iPad Pro (12.9-inch) (1st generation)"
        case .ipadPro12inch92nd:        return "iPad Pro (12.9-inch) (2nd generation)"
        case .ipadPro12inch93rd:        return "iPad Pro (12.9-inch) (3rd generation)"
        case .ipadPro12inch94th:        return "iPad Pro (12.9-inch) (4th generation)"
        case .ipadPro12inch95th:        return "iPad Pro (12.9-inch) (5th generation)"
        case .other:                    return "Unknown"
        }
    }
}

enum DevideModel: Int {
    case iphone_5_5S_5C = 1                          //4''                  screenHeight 1136
    case iphone_6_6Plus_6S_7_8 = 2                   //4.7''                screenHeight 1334
    case iphone_6SPlus_7Plus_8Plus = 3               //5.5''                screenHeight 2208
    case iphone_12Mini_13Mini = 4                    //5.4''                screenHeight 2340
    case iphone_X_XS_11Pro = 5                       //5.8''                screenHeight 2436
    case iphone_XR_11 = 6                            //6.1''                screenHeight 1792
    case iphone_12_12Pro_13_13Pro_14 = 7             //6.1''                screenHeight 2532
    case iphone_14Pro_14ProMax = 8                   //6.1''                screenHeight 2532
    case iphone_XSMax_11ProMax = 9                   //6.5''                screenHeight 2688
    case iphone_12ProMax_13ProMax_14Plus = 10        //6.7''                screenHeight 2778
    
    case ipad_small = 11
    
    case ipad_9Point7InSmall = 12            //iPad 2 (2011), iPad mini (2012)
    //                    screengHeight 1024
    
    case ipad_9Point7InLarge = 13            //iPad (2018, 2017), 9.7-inch iPad Pro (2016), iPad Air 2 (2014), iPad Air (2013), iPad 4 (late 2012), iPad 3 (early 2012), iPad mini (5th generation, 2019), iPad mini 4 (2015), iPad mini 3 (2014), iPad mini 2 (2013),
    //                     screenHeight 2048
    
    case ipad_10Point2In = 14                //iPad (2019)          screenHeight 2160
    
    case ipad_10Point5In = 15                //iPad Air (2019), 10.5-inch iPad Pro (2017)
    //                     screenHeight 2224
    
    case ipad_11In = 16                      //iPad Pro (2018)      screenHeight 2388
    
    case ipad_12Point9In = 17                //iPad Pro (2018, 2017, 2015)
    //                     screenHeight 2732
    
    var screenHeight: Int {
        switch self {
        case .iphone_5_5S_5C:
            return 1136
        case .iphone_6_6Plus_6S_7_8:
            return 1334
        case .iphone_6SPlus_7Plus_8Plus:
            return 2208
        case .iphone_12Mini_13Mini:
            return 2340
        case .iphone_X_XS_11Pro:
            return 2436
        case .iphone_XR_11:
            return 1792
        case .iphone_12_12Pro_13_13Pro_14:
            return 2532
        case .iphone_XSMax_11ProMax:
            return 2688
        case .iphone_12ProMax_13ProMax_14Plus:
            return 2778
        case .ipad_9Point7InSmall:
            return 1024
        case .ipad_9Point7InLarge:
            return 2048
        case .ipad_10Point2In:
            return 2160
        case .ipad_10Point5In:
            return 2224
        case .ipad_11In:
            return 2388
        case .ipad_12Point9In:
            return 2732
        default:
            return 1024     //ipad mini or smaller
        }
    }
    
}
