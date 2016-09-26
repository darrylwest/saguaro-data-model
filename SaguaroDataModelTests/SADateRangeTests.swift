//
//  SADateRangeTests.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import XCTest
import SaguaroDataModel

class SADateRangeTests: XCTestCase {
    let calculator = SADateTimeCalculator()

    func testInstance() {
        let today = Date()
        let dateRange = SADateRange(startDate: today, endDate: today, days: 0)

        XCTAssertNotNil(dateRange.startDate, "start should not be nil")
        XCTAssertNotNil(dateRange.endDate, "end should not be nil")
        XCTAssertEqual(dateRange.days, 0, "should have zero days")
    }

    func testInstancdFromDay() {
        let dateRange = SADateRange(days: 90)

        let comps = calculator.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateRange.startDate)

        print("comps: \( comps )")

        XCTAssertEqual(comps.hour, 0)
        XCTAssertEqual(comps.minute, 0)
        XCTAssertEqual(comps.second, 0)
    }

    func testStartDateInstance() {
        let startDate = Date()
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

        print("distance: \( dateRange.endDate.timeIntervalSince(dateRange.startDate) ) seconds in \( dateRange.days ) days...")

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
        let start = calculator.datePlusDays(Date(), days: 7)
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
        var start = calculator.datePlusDays(Date(), days: 7)
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

        XCTAssertEqual(dateRange.startDate, map["startDate"] as? Date, "start match")
        XCTAssertEqual(dateRange.endDate, map["endDate"] as? Date, "end match")
        XCTAssertEqual(dateRange.days, map["days"] as? Int, "day count match")
    }

    func testFromMap() {
        var range = SAMutableDateRange(dateTimeCalculator:calculator)
        range.days = 25

		let map: [String : AnyObject] = [ "startDate": range.startDate as AnyObject, "endDate": range.endDate as AnyObject, "days":range.days as AnyObject]

        guard let dateRange = SADateRange.fromMap( map ) else {
            XCTFail("should create the date range from map: \( map )")
            return
        }

        XCTAssertEqual(dateRange.startDate, range.startDate, "start match")
        XCTAssertEqual(dateRange.endDate, range.endDate, "end match")
        XCTAssertEqual(dateRange.days, range.days, "day count match")
    }

    func testDefaultDateRangeScrub() {

        let calculator = SADateTimeCalculator.sharedInstance

        var dateRange = calculator.createMutableDateRange()

        dateRange.startDate = Date()
        dateRange.days = 181

        let dtRange = SADateRange.scrubDateRange( dateRange )

        print("input: \( dateRange ) scrubbed range: \( dtRange )")

        XCTAssertEqual(dtRange.days, 181)

        let comps = calculator.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dtRange.startDate)

        // print("comps: \( comps )")

        XCTAssertEqual(comps.hour, 0)
        XCTAssertEqual(comps.minute, 0)
        XCTAssertEqual(comps.second, 0)
    }
}
