//
//  SAValidationDelegate.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

infix operator =~ {}

public func =~ (value : String, pattern : String) -> SARegexMatchResult {
    let nsstr = value as NSString // we use this to access the NSString methods like .length and .substringWithRange(NSRange)
    let options : NSRegularExpressionOptions = []
    do {
        let re = try  NSRegularExpression(pattern: pattern, options: options)
        let all = NSRange(location: 0, length: nsstr.length)
        var matches : Array<String> = []
        re.enumerateMatchesInString(value, options: [], range: all) { (result, flags, ptr) -> Void in
            guard let result = result else { return }
            let string = nsstr.substringWithRange(result.range)
            matches.append(string)
        }
        return SARegexMatchResult(items: matches)
    } catch {
        return SARegexMatchResult(items: [])
    }
}

public struct SARegexMatchCaptureGenerator : GeneratorType {
    public var items: ArraySlice<String>
    public mutating func next() -> String? {
        if items.isEmpty { return nil }
        let ret = items[0]
        items = items[1..<items.count]
        return ret
    }
}

public struct SARegexMatchResult : SequenceType, BooleanType {
    var items: Array<String>
    public func generate() -> SARegexMatchCaptureGenerator {
        return SARegexMatchCaptureGenerator(items: items[0..<items.count])
    }

    public var boolValue: Bool {
        return items.count > 0
    }

    public subscript (i: Int) -> String {
        return items[i]
    }
}

public protocol SAMinMaxRangeType {
    var min:Int { get }
    var max:Int { get }

    func isValid(value:Int) -> Bool
    func isValid(value:String) -> Bool
}

public struct SAMinMaxRange: SAMinMaxRangeType {
    public let min:Int
    public let max:Int

    public func isValid(value:Int) -> Bool {
        return (value >= self.min && value <= self.max)
    }

    public func isValid(value:String) -> Bool {
        return isValid( value.characters.count )
    }

    public init(min:Int, max:Int) {
        self.min = min
        self.max = max
    }
}

// TODO...
//  because swift 2.0 strings are not compatible with NSRegularExpressions, it might
//  be a better idea to use straight logic for validation.

public struct SARegExPatterns {
    static public let Email = "[A-Za-z._%+=]+@[A-Za-z0-9]+\\.[A-Za-z]{2,6}" // "\\w+@\\w.\\w"
}

public class SAValidationDelegate {
    public let passwordMinMax:SAMinMaxRangeType

    public init(passwordMinMax:SAMinMaxRangeType? = SAMinMaxRange(min: 4, max: 40)) {
        self.passwordMinMax = passwordMinMax!
    }

    public func isEmail(value: String) -> Bool {
        let matches = value =~ SARegExPatterns.Email

        return matches.boolValue
    }

    public func isValidUsername(username:String) -> Bool {
        return isEmail(username)
    }

    /// password strings are between 4 and 20 characters, so just test length
    public func isValidPassword(password:String) -> Bool {
        return passwordMinMax.isValid( password )
    }

}
