//
//  SAValidationDelegate.swift
//  SaguaroDataModel
//
//  Created by darryl west on 7/23/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

infix operator =~

public func =~ (value : String, pattern : String) -> SARegexMatchResult {
    let nsstr = value as NSString // we use this to access the NSString methods like .length and .substringWithRange(NSRange)
    let options : NSRegularExpression.Options = []
    do {
        let re = try  NSRegularExpression(pattern: pattern, options: options)
        let all = NSRange(location: 0, length: nsstr.length)
        var matches : Array<String> = []
        re.enumerateMatches(in: value, options: [], range: all) { (result, flags, ptr) -> Void in
            guard let result = result else { return }
            let string = nsstr.substring(with: result.range)
            matches.append(string)
        }
        return SARegexMatchResult(items: matches)
    } catch {
        return SARegexMatchResult(items: [])
    }
}

public func =~ (value : String, pattern : String) -> Bool {
	return (=~)(value, pattern).boolValue
}

public struct SARegexMatchCaptureGenerator : IteratorProtocol {
    public var items: ArraySlice<String>
    
    public mutating func next() -> String? {
        if items.isEmpty {
            return nil
        } else {
        
            let ret = items.remove( at: 0 )

            return ret
        }
    }
}

public struct SARegexMatchResult : Sequence {
    var items: Array<String>
    public func makeIterator() -> SARegexMatchCaptureGenerator {
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

    func isValid(_ value:Int) -> Bool
    func isValid(_ value:String) -> Bool
}

public struct SAMinMaxRange: SAMinMaxRangeType {
    public let min:Int
    public let max:Int

    public func isValid(_ value:Int) -> Bool {
        return (value >= self.min && value <= self.max)
    }

    public func isValid(_ value:String) -> Bool {
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

open class SAValidationDelegate {
    open let passwordMinMax:SAMinMaxRangeType

    public init(passwordMinMax:SAMinMaxRangeType? = SAMinMaxRange(min: 4, max: 40)) {
        self.passwordMinMax = passwordMinMax!
    }

    open func isEmail(_ value: String) -> Bool {
		let matches: SARegexMatchResult = value =~ SARegExPatterns.Email

        return matches.boolValue
    }

    open func isValidUsername(_ username:String) -> Bool {
        return isEmail(username)
    }

    /// password strings are between 4 and 20 characters, so just test length
    open func isValidPassword(_ password:String) -> Bool {
        return passwordMinMax.isValid( password )
    }

}
