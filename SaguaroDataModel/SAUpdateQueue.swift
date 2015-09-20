//
//  UpdateQueue.swift
//  SaguaroDataModel
//
//  Created by darryl west on 9/20/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public class SAUpdateQueue<T> {

    let updateAction:(T) -> ()
    public private(set) var updateQueue:[String:T]
    
    public private(set) var lastQueueTime:NSDate = NSDate()
    public let quietTimeout:NSTimeInterval

    /// construct with an action and the amount of time to wait before invoking the action
    public init(updateAction:(T) -> (), quietTimeout:NSTimeInterval? = 3.0) {
        self.updateAction = updateAction
        self.updateQueue = [String:T]()
        self.quietTimeout = quietTimeout!
    }

    /// invoking the action and each item as it's removed from the queue
    public func flushQueue() {
        // insure a new quiet time...
        lastQueueTime = NSDate(timeIntervalSinceNow: quietTimeout)

        let keys = updateQueue.keys
        for key in keys {
            if let value = updateQueue.removeValueForKey(key) {
                // if the 
                updateAction( value )
            }
        }
    }

    /// check for the update timeout and queue size; if flush is true, then call flush
    public func checkUpdateQueue(flush:Bool? = true) -> Bool {
        if updateQueue.count > 0 && lastQueueTime.isBeforeDate( NSDate() ) {
            if flush == true {
                flushQueue()
            }

            return true
        } else {
            return false
        }
    }

    /// queue a save of the project
    public func queue(id:String, item: T) {
        updateQueue[ id ] = item

        // set the timeout for n seconds
        lastQueueTime = NSDate(timeIntervalSinceNow: 3.0)
    }

    /// return the count of items in the queue
    public var count:Int {
        return updateQueue.count
    }

}