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
    func getDateFormatter(dateFormat:String) -> NSDateFormatter
    func datePlusDays(date:NSDate, days:Int) -> NSDate
    func datePlusMonths(date:NSDate, months:Int) -> NSDate
    func calcMonthsFromDates(fromDate:NSDate, toDate:NSDate) -> Int
    func calcDaysFromDates(fromDate:NSDate, toDate:NSDate) -> Int
    func calcMinutesFromDates(fromDate:NSDate, toDate:NSDate) -> Int
    func createMutableDateRange() -> SAMutableDateRange
    func firstDayOfMonth(fromDate:NSDate?) -> NSDate
    func firstDayOfNextMonth(fromDate:NSDate?) -> NSDate
    func sortDates(reference:NSDate, compareTo:NSDate, order:NSComparisonResult?) -> Bool
    func monthNamesBetweenDates(fromDate:NSDate, toDate:NSDate, dateFormat:String?) -> [String]
    func monthNamesBetweenDates(dateRange:SADateRangeModel, dateFormat:String?) -> [String]
}

/// this makes nsdate not suck so much...
public extension NSDate {
    public func isBeforeDate(date:NSDate) -> Bool {
        return self.timeIntervalSinceDate( date ) < 0
    }
    
    public func isAfterDate(date:NSDate) -> Bool {
        return self.timeIntervalSinceDate( date ) > 0
    }
    
    public func plusDays(days:Int) -> NSDate {
        let dayInterval = NSTimeInterval( days * 24 * 60 * 60 )
        return NSDate(timeInterval: dayInterval, sinceDate: self)
    }
    
    public func plusMinutes(minutes:Int) -> NSDate {
        let minuteInterval = NSTimeInterval( minutes * 60 )
        return NSDate( timeInterval: minuteInterval, sinceDate: self )
    }
    
    public func plusHours(hours: Int) -> NSDate {
        let hourInterval = NSTimeInterval( hours * 60 * 60 )
        return NSDate( timeInterval: hourInterval, sinceDate: self )
    }
}

/// some date helper methods; all date format time zones are zulu
public struct SADateTimeCalculator: SADateTimeCalculatorType {
    public let ISO8601DateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public let dateFormats = [ "MMMM", "MMM", "dd-MMM-yyyy", "dd MMM yyyy","yyyy-MM-dd", "HH:mm:ss" ]

    public let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    public let isoFormatter = NSDateFormatter()
    
    public private(set) var formatters = [String:NSDateFormatter]()
    
    /// the current date with time stripped
    public var today:NSDate {
        return stripTime( NSDate() )
    }

    /// strip the time from the given date
    public func stripTime(date:NSDate) -> NSDate {
        let comps = calendar.components([ .Year, .Month, .Day ], fromDate: date)
        return calendar.dateFromComponents( comps )!
        
    }

    /// format the date to an ISO8601 date/time string
    public func formatISO8601Date(date:NSDate) -> String {
        return isoFormatter.stringFromDate( date )
    }

    /// parse the ISO8601 date/time string and return a date or nil if the parse fails
    public func dateFromISO8601String(dateString:String) -> NSDate? {
        return isoFormatter.dateFromString( dateString )
    }

    /// calculate and return the new date by adding the days
    public func datePlusDays(date:NSDate, days:Int) -> NSDate {
        if days == 0 {
            return date
        }

        let comps = NSDateComponents()
        comps.day = days

        return calendar.dateByAddingComponents(comps, toDate: date, options: [ ])!
    }

    /// calculate and return the new date by adding the number of months
    public func datePlusMonths(date:NSDate, months: Int) -> NSDate {
        if months == 0 {
            return date
        }

        let comps = NSDateComponents()
        comps.month = months

        return calendar.dateByAddingComponents(comps, toDate: date, options: [ ])!
    }
    
    /// calculate the number of months between the two dates rounded
    public func calcMonthsFromDates(fromDate:NSDate, toDate:NSDate) -> Int {
        let comps = calendar.components([ NSCalendarUnit.Month ], fromDate: fromDate, toDate: toDate, options: [ ])
        
        return comps.month
    }

    /// calculate and return the number of days between the two dates
    public func calcDaysFromDates(fromDate:NSDate, toDate:NSDate) -> Int {
        let comps = calendar.components([ NSCalendarUnit.Day ], fromDate: fromDate, toDate: toDate, options: [ ])

        return comps.day
    }
    
    /// calculate and return the number of minutes between the two dates
    public func calcMinutesFromDates(fromDate:NSDate, toDate:NSDate) -> Int {
        let comps = calendar.components([ NSCalendarUnit.Minute ], fromDate: fromDate, toDate: toDate, options: [ ])
        
        return comps.minute
    }
    
    /// create a mutable date range with calculator
    public func createMutableDateRange() -> SAMutableDateRange {
        return SAMutableDateRange( dateTimeCalculator: self )
    }
    
    /// calculate and return the first day of the supplied month
    public func firstDayOfMonth(fromDate:NSDate? = NSDate()) -> NSDate {
        let date = fromDate!
        
        let comps = calendar.components([ .Year, .Month, .Day ], fromDate: date )
        comps.day = 1
        
        return calendar.dateFromComponents( comps )!
    }
    
    /// calculate and return the date of the first day of the month
    public func firstDayOfNextMonth(fromDate:NSDate? = NSDate()) -> NSDate {
        var date = fromDate!
        
        let comps = calendar.components([ .Year, .Month, .Day ], fromDate: date )
        comps.day = 1
        
        date = calendar.dateFromComponents( comps )!
        
        // reset to enable adding...
        comps.day = 0
        comps.year = 0
        comps.month = 1
        
        return calendar.dateByAddingComponents(comps, toDate: date, options: [ ])!
    }
    
    /// return all components from the date
    public func componentsFromDate(date:NSDate) -> NSDateComponents {
        return calendar.components( NSCalendarUnit(rawValue: UInt.max), fromDate: date)
    }
    
    /// return true if the reference is before compareTo date; 
    public func sortDates(reference:NSDate, compareTo:NSDate, order:NSComparisonResult? = NSComparisonResult.OrderedAscending) -> Bool {
        return reference.compare( compareTo ) == order!
    }
    
    /// return an array of month names optionally formatted as MMMM
    public func monthNamesBetweenDates(fromDate:NSDate, toDate:NSDate, dateFormat:String? = "MMMM") -> [String] {
        var names = [String]()
        
        let formatter = getDateFormatter( dateFormat! )
        
        var dt = self.firstDayOfMonth( fromDate )
        let lastDate = self.firstDayOfMonth( toDate )
        while dt.isBeforeDate( lastDate ) {
            names.append( formatter.stringFromDate( dt ))
            dt = datePlusMonths(dt, months: 1)
        }

        names.append( formatter.stringFromDate( dt ))
        
        return names
    }

    /// return the month names
    public func monthNamesBetweenDates(dateRange: SADateRangeModel, dateFormat:String? = "MMMM") -> [String] {
        return monthNamesBetweenDates(dateRange.startDate, toDate: dateRange.endDate, dateFormat: dateFormat)
    }
    
    /// return the formatter from cache, or create new and return
    public func getDateFormatter(dateFormat:String) -> NSDateFormatter {
        if let fmt = formatters[ dateFormat ] {
            return fmt
        } else {
            let fmt = NSDateFormatter()
            fmt.dateFormat = dateFormat
            
            return fmt
        }
    }

    public init() {
        isoFormatter.dateFormat = ISO8601DateTimeFormat
        isoFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        
        for df in dateFormats {
            let fmt = NSDateFormatter()
            fmt.dateFormat = df
            fmt.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            
            formatters[ df ] = fmt
        }
    }
    
    /// return a shared instance; in most cases it's more efficient to use the shared instance
    public static let sharedInstance:SADateTimeCalculator = SADateTimeCalculator()
}

