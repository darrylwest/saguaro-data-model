//
//  UpdateQueue.swift
//  SaguaroDataModel
//
//  Created by darryl west on 9/20/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public protocol SAUpdateQueueable {
    func flushQueue() -> Void
    func checkUpdateQueue(_ flush:Bool?) -> Bool
}

open class SAUpdateQueue<T> : SAUpdateQueueable {

    let updateAction:(T) -> ()
    open fileprivate(set) var updateQueue:[String:T]
    
    open fileprivate(set) var lastQueueTime:Date = Date()
    open let quietTimeout:TimeInterval

    /// construct with an action and the amount of time to wait before invoking the action
    public init(updateAction:@escaping (T) -> (), quietTimeout:TimeInterval? = 3.0) {
        self.updateAction = updateAction
        self.updateQueue = [String:T]()
        self.quietTimeout = quietTimeout!
    }

    /// invoking the action and each item as it's removed from the queue
    open func flushQueue() {
        // insure a new quiet time...
        lastQueueTime = Date(timeIntervalSinceNow: quietTimeout)

        let keys = updateQueue.keys
        for key in keys {
            if let value = updateQueue.removeValue( forKey: key ) {
                updateAction( value )
            }
        }
    }

    /// check for the update timeout and queue size; if flush is true, then call flush
    open func checkUpdateQueue(_ flush:Bool? = true) -> Bool {
        if updateQueue.count > 0 && lastQueueTime.isBeforeDate( Date() ) {
            if flush == true {
                flushQueue()
            }

            return true
        } else {
            return false
        }
    }

    /// queue a save of the project
    open func queue(_ id:String, item: T) {
        updateQueue[ id ] = item

        // set the timeout for n seconds
        lastQueueTime = Date(timeIntervalSinceNow: quietTimeout)
    }

    /// return the count of items in the queue
    open var count:Int {
        return updateQueue.count
    }
}
