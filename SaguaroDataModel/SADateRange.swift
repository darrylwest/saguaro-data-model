//
//  SADateRange.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation
import SaguaroJSON

public protocol SADateRangeModel: SAMappable, CustomStringConvertible {
    var startDate:NSDate { get }
    var endDate:NSDate { get }
    var days: Int { get }
}

extension SADateRangeModel {
    public var description: String {
        return "start: \( self.startDate ) end: \( self.endDate ) days: \( self.days )"
    }
}

public struct SADateRange: SADateRangeModel {
    public let startDate: NSDate
    public let endDate: NSDate
    public let days: Int
    
    public init(days:Int) {
        let calculator = SADateTimeCalculator.sharedInstance
        self.startDate = calculator.today
        self.endDate = self.startDate.dateByAddingTimeInterval( NSTimeInterval( 60 * 60 * 24 * days ))
        self.days = days
    }

    public init(startDate:NSDate, endDate:NSDate, days:Int = 0) {
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }

    public init(dateRange: SADateRangeModel) {
        self.startDate = dateRange.startDate
        self.endDate = dateRange.endDate
        self.days = dateRange.days
    }
}

public struct SAMutableDateRange: SADateRangeModel {
    public let calculator:SADateTimeCalculator

    public var startDate: NSDate {
        didSet {
            let dt = calculator.datePlusDays(startDate, days: days)
            if dt != endDate {
                endDate = dt
            }
        }
    }

    public var endDate: NSDate {
        didSet {
            let n = calculator.calcDaysFromDates(startDate, toDate: endDate)
            if n != days {
                days = n
            }
        }
    }

    public var days: Int {
        didSet {
            let dt = calculator.datePlusDays(startDate, days: days)
            if dt != endDate {
                endDate = dt
            }
        }
    }

    public init(dateTimeCalculator:SADateTimeCalculator) {
        self.calculator = dateTimeCalculator

        self.startDate = calculator.today
        self.days = 0
        self.endDate = calculator.today
    }

    public init(dateTimeCalculator:SADateTimeCalculator, dateRange: SADateRangeModel) {
        self.calculator = dateTimeCalculator

        self.startDate = dateRange.startDate
        self.endDate = dateRange.endDate
        self.days = dateRange.days
    }

    public init(dateTimeCalculator:SADateTimeCalculator, startDate:NSDate, endDate:NSDate, days:Int) {
        self.calculator = dateTimeCalculator

        self.startDate = startDate
        self.endDate = endDate
        self.days = days
    }
}

public extension SADateRangeModel {
    /// convert this date range to a map<String,AnyObject> of startDate, endDate and days
    func toMap() -> [String:AnyObject] {
        let map = [
            "startDate": self.startDate,
            "endDate": self.endDate,
            "days":self.days
        ]

        return map
    }

    /// convert this map to a date range or return nil
    static func fromMap(map: [String:AnyObject]) -> SADateRange? {
        let parser = JNParser()
        guard let startDate = parser.parseDate( map[ "startDate" ] ),
            let endDate = parser.parseDate( map[ "endDate" ] ),
            let days = map[ "days" ] as? Int else {
                return nil
        }

        return SADateRange(startDate: startDate, endDate: endDate, days: days)
    }

    /// scrub the date range to insure only year/month/day with zero times
    public static func scrubDateRange(dateRange:SADateRangeModel) -> SADateRangeModel {
        let calculator = SADateTimeCalculator.sharedInstance

        let sdt = calculator.stripTime( dateRange.startDate )
        let edt = calculator.datePlusDays( sdt, days: dateRange.days )

        return SADateRange( startDate:sdt, endDate:edt, days: dateRange.days )
    }
}