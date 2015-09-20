//
//  SAStack.swift
//  SaguaroDataModel
//
//  Created by darryl west on 8/16/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public struct SAStack<T> {
    public let capLimit:Int
    var items:[T]

    /// create the items array
    public init(capLimit:Int? = 0) {
        self.capLimit = capLimit!
        self.items = [T]()
    }

    /// push a new item onto the stack; return the item to enable chaining
    public mutating func push(item: T) -> T {
        items.append(item)

        if (capLimit > 0 && items.count > capLimit) {
            items.removeAtIndex( 0 )
        }

        return item
    }

    /// pop the top item off the stack or return nil if stack is empty
    public mutating func pop() -> T? {
        if (items.isEmpty) {
            return nil
        } else {
            return items.removeLast()
        }
    }

    /// return the top if the stack or nil if the stack is empty
    public func peek() -> T? {
        if (items.isEmpty) {
            return nil
        } else {
            return items.last
        }
    }

    /// return the total number of stack items
    public var count:Int {
        return items.count
    }

    /// return true if the stack is empty
    public var isEmpty:Bool {
        return items.count == 0
    }
}