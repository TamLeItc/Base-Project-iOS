//
//  EventLogger.swift
//  i270-locksafe
//
//  Created by Tam Le on 13/04/2023.
//

import Foundation

protocol EventLogger: EventLoggerImp {
    func configSearchAds()
    func configsAppFlyer()
    func configAdjust()
    func logEventInApp(_ product: IAPProduct?, type: LogEventType)
}
