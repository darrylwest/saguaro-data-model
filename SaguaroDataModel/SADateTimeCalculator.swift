//
//  SADateTimeCalculator.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public protocol SADateTimeCalculatorType {
    var ISO8601DateTimeFormat:String { get }
    var calendar:NSCalendar { get }
    var isoFormatter:NSDateFormatter { get }
    var today:NSDate { get }
    func stripTime(date:NSDate) -> NSDate
    func formatISO8601Date(date:NSDate) -> String
    func datePlusDays(date:NSDate, days:Int) -> NSDate
    func datePlusMonths(date:NSDate, months:Int) -> NSDate
    func calcDaysFromDates(fromDate:NSDate, toDate:NSDate) -> Int
    func calcMinutesFromDates(fromDate:NSDate, toDate:NSDate) -> Int
    func createMutableDateRange() -> SAMutableDateRange
}

public struct SADateTimeCalculator: SADateTimeCalculatorType {
    public let ISO8601DateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    public let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    public let isoFormatter = NSDateFormatter()

    public var today:NSDate {
        return stripTime(NSDate())
    }

    public func stripTime(date:NSDate) -> NSDate {
        let comps = calendar.components([ .Year, .Month, .Day ], fromDate: date)
        return calendar.dateFromComponents( comps )!
    }

    public func formatISO8601Date(date:NSDate) -> String {
        return isoFormatter.stringFromDate( date )
    }

    public func dateFromISO8601String(dateString:String) -> NSDate? {
        return isoFormatter.dateFromString( dateString )
    }

    public func datePlusDays(date:NSDate, days:Int) -> NSDate {
        if days == 0 {
            return date
        }

        let comps = NSDateComponents()
        comps.day = days

        return calendar.dateByAddingComponents(comps, toDate: date, options: [ ])!
    }

    public func datePlusMonths(date:NSDate, months: Int) -> NSDate {
        if months == 0 {
            return date
        }

        let comps = NSDateComponents()
        comps.month = months

        return calendar.dateByAddingComponents(comps, toDate: date, options: [ ])!
    }

    public func calcDaysFromDates(fromDate:NSDate, toDate:NSDate) -> Int {
        let comps = calendar.components([ NSCalendarUnit.Day ], fromDate: fromDate, toDate: toDate, options: [ ])

        return comps.day
    }
    
    public func calcMinutesFromDates(fromDate:NSDate, toDate:NSDate) -> Int {
        let comps = calendar.components([ NSCalendarUnit.Minute ], fromDate: fromDate, toDate: toDate, options: [ ])
        
        return comps.minute
    }
    
    /// create a mutable date range with calculator
    public func createMutableDateRange() -> SAMutableDateRange {
        return SAMutableDateRange( dateTimeCalculator: self )
    }

    public init() {
        isoFormatter.dateFormat = ISO8601DateTimeFormat
        isoFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    }
    
    public static let sharedInstance:SADateTimeCalculator = SADateTimeCalculator()
}