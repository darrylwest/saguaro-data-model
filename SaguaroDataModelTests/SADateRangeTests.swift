//
//  SADateRangeTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
@testable import SaguaroDataModel

class SADateRangeTests: XCTestCase {
    let calculator = SADateTimeCalculator()

    func testInstance() {
        let today = NSDate()
        let dateRange = SADateRange(startDate: today, endDate: today, days: 0)

        XCTAssertNotNil(dateRange.startDate, "start should not be nil")
        XCTAssertNotNil(dateRange.endDate, "end should not be nil")
        XCTAssertEqual(dateRange.days, 0, "should have zero days")
    }

    func testStartDateInstance() {
        let startDate = NSDate()
        let days = 2
        let endDate = calculator.datePlusDays(startDate, days: days)

        let dateRange = SADateRange(startDate: startDate, endDate: endDate, days: days)

        XCTAssertNotNil(dateRange.startDate, "start should not be nil")
        XCTAssertNotNil(dateRange.endDate, "end should not be nil")
        XCTAssertEqual(dateRange.days, 2, "should have zero days")
    }

    func testMutableDateRange() {
        var dateRange = SAMutableDateRange(dateTimeCalculator:calculator)

        XCTAssertEqual(dateRange.days, 0, "should have zero days")

        dateRange.days = 5

        print("distance: \( dateRange.endDate.timeIntervalSinceDate( dateRange.startDate ) ) seconds in \( dateRange.days ) days...")

        XCTAssertNotNil(dateRange.startDate, "start should not be nil")
        XCTAssertNotNil(dateRange.endDate, "end should not be nil")
        XCTAssertEqual(dateRange.days, 5, "should have five days")

        dateRange.startDate = calculator.today

        XCTAssertNotNil(dateRange.startDate, "start should not be nil")
        XCTAssertEqual(dateRange.days, 5, "should have five days")
        // TODO : test that end date is not today + 5

        let endDate = calculator.datePlusDays(dateRange.startDate, days: 10 )
        dateRange.endDate = endDate

        XCTAssertEqual(dateRange.endDate, endDate, "should match")
        XCTAssertEqual(dateRange.days, 10, "should have new days value")
    }

    func testEndDateChange() {
        let start = calculator.datePlusDays(NSDate(), days: 7)
        let days = 10
        var stop = calculator.datePlusDays(start, days: days)

        var dateRange = SAMutableDateRange(dateTimeCalculator: calculator,
            startDate: start,
            endDate: stop,
            days: days
        )

        XCTAssertEqual(dateRange.startDate, start, "start dates should match")
        XCTAssertEqual(dateRange.endDate, stop, "end dates should match")
        XCTAssertEqual(dateRange.days, days, "days should match")

        // create the new stop
        stop = calculator.datePlusDays(stop, days: 20)
        dateRange.endDate = stop

        XCTAssertEqual(dateRange.startDate, start, "new start date should match")
        XCTAssertEqual(dateRange.days, 30, "days should still match")
        XCTAssertEqual(dateRange.endDate, stop, "new end dates should match")
    }

    func testStartDateChange() {
        var start = calculator.datePlusDays(NSDate(), days: 7)
        let days = 10
        var stop = calculator.datePlusDays(start, days: days)

        var dateRange = SAMutableDateRange(dateTimeCalculator: calculator,
            startDate: start,
            endDate: stop,
            days: days
        )

        XCTAssertEqual(dateRange.startDate, start, "start dates should match")
        XCTAssertEqual(dateRange.endDate, stop, "end dates should match")
        XCTAssertEqual(dateRange.days, days, "days should match")

        // create the new start / stop days
        start = calculator.datePlusDays(start, days: 20)
        stop = calculator.datePlusDays(stop, days: 20)
        dateRange.startDate = start

        XCTAssertEqual(dateRange.startDate, start, "new start date should match")
        XCTAssertEqual(dateRange.days, days, "days should still match")
        XCTAssertEqual(dateRange.endDate, stop, "new end dates should match")
    }

    func testToMap() {
        var dateRange = SAMutableDateRange(dateTimeCalculator:calculator)
        dateRange.days = 10

        let map = dateRange.toMap()

        XCTAssertEqual(dateRange.startDate, map["startDate"] as! NSDate, "start match")
        XCTAssertEqual(dateRange.endDate, map["endDate"] as! NSDate, "end match")
        XCTAssertEqual(dateRange.days, 10, "day count match")
    }

    func testFromMap() {

    }

    
}
