//
//  Int+Extension.swift
//  MinskMetroSchedule
//
//  Created by Максим Журавлев on 9.11.22.
//

import Foundation

extension Int {
    func decoderDt(format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.timeZone = .gmt
        dayTimePeriodFormatter.dateFormat = format
        return dayTimePeriodFormatter.string(from: date as Date)
    }
}
