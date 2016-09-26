//
//  SADateTimeCalculator.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation
import SaguaroJSON

public protocol SADateTimeCalculatorType {
    var ISO8601DateTimeFormat:String { get }
    var calendar:Calendar { get }
    var isoFormatter:DateFormatter { get }
    var today:Date { get }
    func stripTime(_ date:Date) -> Date
    func formatISO8601Date(_ date:Date) -> String
    func getDateFormatter(_ dateFormat:String) -> DateFormatter
    func datePlusDays(_ date:Date, days:Int) -> Date
    func datePlusMonths(_ date:Date, months:Int) -> Date
    func calcMonthsFromDates(_ fromDate:Date, toDate:Date) -> Int
    func calcDaysFromDates(_ fromDate:Date, toDate:Date) -> Int
    func calcMinutesFromDates(_ fromDate:Date, toDate:Date) -> Int
    func createMutableDateRange() -> SAMutableDateRange
    func firstDayOfMonth(_ fromDate:Date?) -> Date
    func firstDayOfNextMonth(_ fromDate:Date?) -> Date
    func sortDates(_ reference:Date, compareTo:Date, order:ComparisonResult?) -> Bool
    func monthNamesBetweenDates(_ fromDate:Date, toDate:Date, dateFormat:String?) -> [String]
    func monthNamesBetweenDates(_ dateRange:SADateRangeModel, dateFormat:String?) -> [String]
}

/// this makes nsdate not suck so much...
public extension Date {

    /// return true if the supplied date is before the reference
    public func isBeforeDate(_ date:Date) -> Bool {
        return self.compare( date ) == ComparisonResult.orderedAscending
    }

    /// return true if the supplied date is after the reference
    public func isAfterDate(_ date:Date) -> Bool {
        return self.compare( date ) == ComparisonResult.orderedDescending
    }

    /// return true if the two dates match (OrderedSame)
    public func equals(_ date:Date) -> Bool {
        return self.compare( date ) == ComparisonResult.orderedSame
    }

    /// return a new date by adding the number of days to the reference
    public func plusDays(_ days:Int) -> Date {
        let dayInterval = TimeInterval( days * 24 * 60 * 60 )
        return Date(timeInterval: dayInterval, since: self)
    }

    /// return a new date by adding the number of minutes to the reference
    public func plusMinutes(_ minutes:Int) -> Date {
        let minuteInterval = TimeInterval( minutes * 60 )
        return Date( timeInterval: minuteInterval, since: self )
    }

    /// return a new date by adding the hours to reference
    public func plusHours(_ hours: Int) -> Date {
        let hourInterval = TimeInterval( hours * 60 * 60 )
        return Date( timeInterval: hourInterval, since: self )
    }

    /// return the standard JSON date string compatible with javascript / node and safe for over-the-wire
    public func toJSONString() -> String {
        return JSON.jnparser.stringFromDate( self )
    }
}

/// some date helper methods; all date format time zones are zulu
public struct SADateTimeCalculator: SADateTimeCalculatorType {
    public let dateFormats = [ "MMMM", "MMM", "dd-MMM-yyyy", "dd MMM yyyy","yyyy-MM-dd", "HH:mm:ss" ]
    public let ISO8601DateTimeFormat = JSON.DateFormatString

	public let calendar: Calendar
    public let isoFormatter = DateFormatter()
    
    public fileprivate(set) var formatters = [String:DateFormatter]()
    
    /// the current date with time stripped
    public var today:Date {
        return stripTime( Date() )
    }

    /// strip the time from the given date
    public func stripTime(_ date:Date) -> Date {
        let comps = (calendar as NSCalendar).components([ .year, .month, .day ], from: date)
        return calendar.date( from: comps )!
        
    }

    /// format the date to an ISO8601 date/time string
    public func formatISO8601Date(_ date:Date) -> String {
        return isoFormatter.string( from: date )
    }

    /// parse the ISO8601 date/time string and return a date or nil if the parse fails
    public func dateFromISO8601String(_ dateString:String) -> Date? {
        return isoFormatter.date( from: dateString )
    }

    /// parse a json date string and return the date or nil
    public func dateFromJSONDateString(_ jsonDateString:String) -> Date? {
        return JSON.jnparser.dateFromString( jsonDateString )
    }

    /// calculate and return the new date by adding the days
    public func datePlusDays(_ date:Date, days:Int) -> Date {
        if days == 0 {
            return date
        }

        var comps = DateComponents()
        comps.day = days

        return (calendar as NSCalendar).date(byAdding: comps, to: date, options: [ ])!
    }

    /// calculate and return the new date by adding the number of months
    public func datePlusMonths(_ date:Date, months: Int) -> Date {
        if months == 0 {
            return date
        }

        var comps = DateComponents()
        comps.month = months

        return (calendar as NSCalendar).date(byAdding: comps, to: date, options: [ ])!
    }
    
    /// calculate the number of months between the two dates rounded
    public func calcMonthsFromDates(_ fromDate:Date, toDate:Date) -> Int {
        let comps = (calendar as NSCalendar).components([ NSCalendar.Unit.month ], from: fromDate, to: toDate, options: [ ])
        
        return comps.month!
    }

    /// calculate and return the number of days between the two dates
    public func calcDaysFromDates(_ fromDate:Date, toDate:Date) -> Int {
        let comps = (calendar as NSCalendar).components([ NSCalendar.Unit.day ], from: fromDate, to: toDate, options: [ ])

        return comps.day!
    }
    
    /// calculate and return the number of minutes between the two dates
    public func calcMinutesFromDates(_ fromDate:Date, toDate:Date) -> Int {
        let comps = (calendar as NSCalendar).components([ NSCalendar.Unit.minute ], from: fromDate, to: toDate, options: [ ])
        
        return comps.minute!
    }
    
    /// create a mutable date range with calculator
    public func createMutableDateRange() -> SAMutableDateRange {
        return SAMutableDateRange( dateTimeCalculator: self )
    }
    
    /// calculate and return the first day of the supplied month
    public func firstDayOfMonth(_ fromDate:Date? = Date()) -> Date {
        let date = fromDate!
        
        var comps = (calendar as NSCalendar).components([ .year, .month, .day ], from: date )
        comps.day = 1
        
        return calendar.date( from: comps )!
    }
    
    /// calculate and return the date of the first day of the month
    public func firstDayOfNextMonth(_ fromDate:Date? = Date()) -> Date {
        var date = fromDate!
        
        var comps = (calendar as NSCalendar).components([ .year, .month, .day ], from: date )
        comps.day = 1
        
        date = calendar.date( from: comps )!
        
        // reset to enable adding...
        comps.day = 0
        comps.year = 0
        comps.month = 1
        
        return (calendar as NSCalendar).date(byAdding: comps, to: date, options: [ ])!
    }
    
    /// return all components from the date
    public func componentsFromDate(_ date:Date) -> DateComponents {
        return (calendar as NSCalendar).components( NSCalendar.Unit(rawValue: UInt.max), from: date)
    }
    
    /// return true if the reference is before compareTo date; 
    public func sortDates(_ reference:Date, compareTo:Date, order:ComparisonResult? = ComparisonResult.orderedAscending) -> Bool {
        return reference.compare( compareTo ) == order!
    }
    
    /// return an array of month names optionally formatted as MMMM
    public func monthNamesBetweenDates(_ fromDate:Date, toDate:Date, dateFormat:String? = "MMMM") -> [String] {
        var names = [String]()
        
        let formatter = getDateFormatter( dateFormat! )
        
        var dt = self.firstDayOfMonth( fromDate )
        let lastDate = self.firstDayOfMonth( toDate )
        while dt.isBeforeDate( lastDate ) {
            names.append( formatter.string( from: dt ))
            dt = datePlusMonths(dt, months: 1)
        }

        names.append( formatter.string( from: dt ))
        
        return names
    }

    /// return the month names
    public func monthNamesBetweenDates(_ dateRange: SADateRangeModel, dateFormat:String? = "MMMM") -> [String] {
        return monthNamesBetweenDates(dateRange.startDate as Date, toDate: dateRange.endDate as Date, dateFormat: dateFormat)
    }
    
    /// return the formatter from cache, or create new and return
    public func getDateFormatter(_ dateFormat:String) -> DateFormatter {
        if let fmt = formatters[ dateFormat ] {
            // insure that this is the correct format and hasn't been externally modified
            fmt.dateFormat = dateFormat
            return fmt
        } else {
            let fmt = DateFormatter()
            fmt.dateFormat = dateFormat
            
            return fmt
        }
    }

    public init() {
        isoFormatter.dateFormat = ISO8601DateTimeFormat

		// No non-failable initializer is available, but it shouldn't ever return nil
		// However, rather than force unwrapping, it's probably better to give another timezone 
		// than making the app crash
		let timeZone = TimeZone(secondsFromGMT: 0) ?? TimeZone.current
        isoFormatter.timeZone = timeZone

		var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = timeZone
		self.calendar = calendar
        
        for df in dateFormats {
            let fmt = DateFormatter()
            fmt.dateFormat = df
            fmt.timeZone = TimeZone(secondsFromGMT: 0)
            
            formatters[ df ] = fmt
        }
    }
    
    /// return a shared instance; in most cases it's more efficient to use the shared instance
    public static let sharedInstance:SADateTimeCalculator = SADateTimeCalculator()
}

