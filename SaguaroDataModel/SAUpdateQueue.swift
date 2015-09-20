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

    public init(updateAction:(T) -> (), quietTimeout:NSTimeInterval? = 3.0) {
        self.updateAction = updateAction
        self.updateQueue = [String:T]()
        self.quietTimeout = quietTimeout!
    }

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

    public func checkUpdateQueue() {
        if updateQueue.count > 0 && lastQueueTime.isBeforeDate( NSDate() ) {
            flushQueue()
        }
    }

    /// queue a save of the project
    public func queue(id:String, item: T) {
        updateQueue[ id ] = item

        // set the timeout for n seconds
        lastQueueTime = NSDate(timeIntervalSinceNow: 3.0)
    }

    public var count:Int {
        return updateQueue.count
    }

}