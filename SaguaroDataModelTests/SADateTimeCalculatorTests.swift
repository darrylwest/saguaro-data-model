//
//  SADateTimeCalculatorTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SADateTimeCalculatorTests: XCTestCase {
    let calculator = SADateTimeCalculator()

    func testInstance() {
        let dtc = SADateTimeCalculator()

        XCTAssertNotNil(dtc.ISO8601DateTimeFormat, "should not be nil")
        XCTAssertNotNil(dtc.calendar, "calendar should not be nil")
        XCTAssertNotNil(dtc.isoFormatter)
    }
    
    func testSharedInstance() {
        let shared = SADateTimeCalculator.sharedInstance
        
        XCTAssertNotNil( shared.ISO8601DateTimeFormat, "not nil")
        let formatter = shared.getDateFormatter("dd-MMM-yyyy")
        XCTAssertNotNil( formatter )
    }

    func testToday() {
        let calendar = calculator.calendar
        let today = calculator.today
        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: today)
        let date = calendar.dateFromComponents( comps )!

        XCTAssertNotNil(today)

        XCTAssertEqual(today, date, "should match")
        XCTAssertTrue(comps.year >= 2015, "should be greater than epoch")
        XCTAssertTrue(comps.month > 0 && comps.month < 13, "between 1..12")
        XCTAssertTrue(comps.day > 0 && comps.day < 32, "between 1..31 days")
        XCTAssertEqual(comps.hour, 0, "should be zero hours")
        XCTAssertEqual(comps.minute, 0, "should be zero minutes")
        XCTAssertEqual(comps.second, 0, "should be zero seconds")
    }

    func testStripTime() {
        let calendar = calculator.calendar
        let now = NSDate()

        let today = calculator.stripTime( now )

        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: today)

        XCTAssertTrue(comps.year >= 2015, "should be greater than epoch")
        XCTAssertTrue(comps.month > 0 && comps.month < 13, "between 1..12")
        XCTAssertTrue(comps.day > 0 && comps.day < 32, "between 1..31 days")
        XCTAssertEqual(comps.hour, 0, "should be zero hours")
        XCTAssertEqual(comps.minute, 0, "should be zero minutes")
        XCTAssertEqual(comps.second, 0, "should be zero seconds")
    }

    func testDateFromISO8601String() {
        let calendar = calculator.calendar
        let date = calculator.dateFromISO8601String("2015-01-01T10:01:02.123Z")!
        print("iso date: \( date )")

        XCTAssertNotNil(date, "should not be nil")

        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)
        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 1, "month")
        XCTAssertEqual(comps.day, 1, "day")
        XCTAssertEqual(comps.hour, 10, "hour")
        XCTAssertEqual(comps.minute, 1, "minute")
        XCTAssertEqual(comps.second, 2, "second")
    }

    func testFormatISO8601Date() {
        let calendar = calculator.calendar
        guard let dt = calculator.isoFormatter.dateFromString("2015-05-06T09:30:59.999Z") else {
            XCTFail("date broken")
            return
        }

        let dtstr = calculator.formatISO8601Date( dt )
        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: dt)

        XCTAssertNotNil(dtstr, "date string should not be nil")
        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 5, "month")
        XCTAssertEqual(comps.day, 6, "day")
        XCTAssertEqual(comps.hour, 9, "hour")
        XCTAssertEqual(comps.minute, 30, "minute")
        XCTAssertEqual(comps.second, 59, "second")
    }

    func testDatePlusMonths() {
        let calendar = calculator.calendar
        guard let ref = calculator.dateFromISO8601String("2015-06-15T00:00:00.000Z") else {
            XCTFail("ref date failed")
            return
        }

        var date = calculator.datePlusMonths(ref, months: 6)
        var comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)

        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 12, "month")
        XCTAssertEqual(comps.day, 15, "day")
        XCTAssertEqual(comps.hour, 0, "hour")
        XCTAssertEqual(comps.minute, 0, "minute")
        XCTAssertEqual(comps.second, 0, "second")

        date = calculator.datePlusMonths(ref, months: 12)
        comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)

        XCTAssertEqual(comps.year, 2016, "year")
        XCTAssertEqual(comps.month, 6, "month")
        XCTAssertEqual(comps.day, 15, "day")
        XCTAssertEqual(comps.hour, 0, "hour")
        XCTAssertEqual(comps.minute, 0, "minute")
        XCTAssertEqual(comps.second, 0, "second")

        date = calculator.datePlusMonths(ref, months: 0)
        XCTAssertEqual(date, ref, "dates should match")

    }

    func testDatePlusDays() {
        let calendar = calculator.calendar
        guard let ref = calculator.dateFromISO8601String("2015-01-01T00:00:00.000Z") else {
            XCTFail("should create the reference date")
            return
        }

        var date = calculator.datePlusDays(ref, days: 7)
        var comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)

        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 1, "month")
        XCTAssertEqual(comps.day, 8, "day calc")

        date = calculator.datePlusDays(ref, days: 45)
        comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)

        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 2, "month")
        XCTAssertEqual(comps.day, 15, "day calc")

        date = calculator.datePlusDays(ref, days: -7)
        comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)

        XCTAssertEqual(comps.year, 2014, "year")
        XCTAssertEqual(comps.month, 12, "month")
        XCTAssertEqual(comps.day, 25, "day calc")
    }
    
    func testCreateMutableDateRange() {
        var range = calculator.createMutableDateRange()
        
        XCTAssertNotNil(range.startDate, "should not be nil")
        XCTAssertNotNil(range.endDate, "should not be nil")
        XCTAssertEqual(range.days, 0, "should be zero")
        
        range.days = 180
        XCTAssertEqual(range.days, 180, "should be zero")
    }
    
    func testFirstDayOfMonth() {
        let refDate = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")
        let calendar = calculator.calendar
        let date = calculator.firstDayOfMonth( refDate )
        
        XCTAssertNotNil(date, "should not be nil")
        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)
        XCTAssertEqual(comps.day, 1, "first day")
        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 8, "month check")
    }
    
    func testFirstDayOfNextMonth() {
        let refDate = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")
        let calendar = calculator.calendar
        let date = calculator.firstDayOfNextMonth( refDate )
        
        XCTAssertNotNil(date, "should not be nil")
        
        let comps = calendar.components([ .Year, .Month, .Day, .Hour, .Minute, .Second ], fromDate: date)
        XCTAssertEqual(comps.day, 1, "first day")
        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 9, "month check")
    }
    
    func testComponentsFromDate() {
        let refDate = calculator.dateFromISO8601String("2015-08-14T13:45:33.987Z")!
        let comps = calculator.componentsFromDate( refDate )
        
        print( comps )
        XCTAssertEqual(comps.era, 1, "era")
        XCTAssertEqual(comps.year, 2015, "year")
        XCTAssertEqual(comps.month, 8, "month")
        XCTAssertEqual(comps.day, 14, "day")
        XCTAssertEqual(comps.hour, 13, "hour")
        XCTAssertEqual(comps.minute, 45, "minute")
        XCTAssertEqual(comps.second, 33, "second")
        XCTAssertEqual(comps.weekOfMonth, 3, "week of month")
        XCTAssertEqual(comps.weekOfYear, 33, "week of year")
        XCTAssertEqual(comps.weekday, 6, "friday")
        XCTAssertEqual(comps.weekdayOrdinal, 2, "second friday of the month")
    }
    
    func testSortDates() {
        let dt1 = calculator.dateFromISO8601String("2015-08-14T13:45:33.987Z")!
        let dt2 = calculator.dateFromISO8601String("2015-08-15T13:45:33.987Z")!
        let dt3 = calculator.dateFromISO8601String("2015-08-13T13:45:33.987Z")!
        let dt4 = calculator.dateFromISO8601String("2015-08-14T13:45:34.987Z")!
        
        XCTAssertEqual(calculator.sortDates( dt1, compareTo: dt2 ), true, "dt1 < dt2")
        XCTAssertEqual(calculator.sortDates( dt1, compareTo: dt3 ), false, "dt1 > dt3")
        XCTAssertEqual(calculator.sortDates( dt1, compareTo: dt4 ), true, "dt1 > dt4")
        XCTAssertEqual(calculator.sortDates( dt1, compareTo: dt2, order:NSComparisonResult.OrderedDescending ), false, "dt1 < dt2")
    }
    
    
    // extensions
    func testIsBeforeDate() {
        let dt1 = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")!
        let dt2 = calculator.dateFromISO8601String("2015-08-15T13:45:33.987Z")!
        
        XCTAssertEqual( dt1.isBeforeDate( dt2 ), true, "dt1 < dt2")
        XCTAssertEqual( dt2.isAfterDate( dt1 ), true, "dt2 > dt1")
    }
    
    func testPlusDays() {
        let dt1 = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")!
        let dt2 = dt1.plusDays(1)
        
        XCTAssert( dt1.isBeforeDate( dt2 ))
        XCTAssertEqual( calculator.datePlusDays(dt1, days: 1), dt2, "d1/d2")
    }
    
    func testPlusMinutes() {
        let dt1 = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")!
        let dt2 = dt1.plusMinutes(10)
        
        XCTAssert(dt1.isBeforeDate( dt2 ))
        XCTAssertEqual( dt2.timeIntervalSinceDate(dt1), 10 * 60, "10 minutes")
    }
    
    func testPlusHours() {
        let dt1 = calculator.dateFromISO8601String("2015-08-14T00:00:00.000Z")!
        let dt2 = dt1.plusHours( 5 )
        
        XCTAssert( dt1.isBeforeDate( dt2 ))
        XCTAssertEqual(dt2.timeIntervalSinceDate( dt1 ), 5 * 60 * 60, "hours")
    }
    
    func testCalcMonthsFromDates() {
        let dt1 = calculator.dateFromISO8601String("2015-08-01T00:00:00.000Z")!
        var dt2 = calculator.dateFromISO8601String("2016-08-31T00:00:00.000Z")!
        
        var months = calculator.calcMonthsFromDates(dt1, toDate:dt2)
        XCTAssertEqual(months, 12, "should be 12")
        
        dt2 = calculator.dateFromISO8601String("2016-12-31T00:00:00.000Z")!
        months = calculator.calcMonthsFromDates(dt1, toDate:dt2)
        XCTAssertEqual(months, 16, "should be 16")
        
        dt2 = calculator.dateFromISO8601String("2017-01-01T00:00:00.000Z")!
        months = calculator.calcMonthsFromDates(dt1, toDate:dt2)
        XCTAssertEqual(months, 17, "should be 16")
    }
    
    func testMonthNamesBetweenDates() {
        var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let dt1 = calculator.dateFromISO8601String("2015-01-01T00:00:00.000Z")!
        let dt2 = calculator.dateFromISO8601String("2015-12-31T00:00:00.000Z")!

        print( "dt1: \( dt1 ), dt2: \( dt2 )")
        
        var names = calculator.monthNamesBetweenDates(dt1, toDate: dt2)
        
        print( names )
        
        XCTAssertNotNil( names );
        XCTAssertEqual(names.count, 12, "count")
        
        for name in names {
            if months.isEmpty {
                XCTFail("months are empty for \( name )")
            } else {
                XCTAssertEqual(name, months.removeAtIndex(0))
            }
        }
        
        months = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ]
        names = calculator.monthNamesBetweenDates(dt1, toDate: dt2, dateFormat:"MMM")
        print( names )
        
        for name in names {
            if months.isEmpty {
                XCTFail("months are empty for \( name )")
            } else {
                XCTAssertEqual(name, months.removeAtIndex(0))
            }
        }
        
        names = calculator.monthNamesBetweenDates(dt1, toDate: calculator.datePlusMonths( dt2, months:10), dateFormat:"MMM-yyyy")
        print(names)
    }

    func testMonthNamesBetweenDateRange() {
        var months = [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        let dt1 = calculator.dateFromISO8601String("2015-01-01T00:00:00.000Z")!
        let dt2 = calculator.dateFromISO8601String("2015-12-31T00:00:00.000Z")!
        let range = SADateRange(startDate: dt1, endDate: dt2)

        print("range: \( range )")

        let names = calculator.monthNamesBetweenDates(range)

        print( names )

        XCTAssertNotNil( names );
        XCTAssertEqual(names.count, 12, "count")

        for name in names {
            if months.isEmpty {
                XCTFail("months are empty for \( name )")
            } else {
                XCTAssertEqual(name, months.removeAtIndex(0))
            }
        }
    }
}
