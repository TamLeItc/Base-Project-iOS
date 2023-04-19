//
//  Events.swift
//  BaseProject
//
//  Created by Tam Le on 8/19/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

class BusEvents {
    
    struct ChangePage: BusEvent {
        let page: Int
    }
    
    struct PageChanged: BusEvent {
        let page: Int
    }
    
    struct DidBecomeActive: BusEvent {
        
    }
}
