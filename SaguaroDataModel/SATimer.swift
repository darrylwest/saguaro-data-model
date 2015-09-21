//
//  SATimer.swift
//  SaguaroDataModel
//
//  Created by darryl west on 9/20/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

private class NSTimerActor {
    let block: () -> Void

    init(_ block: () -> Void) {
        self.block = block
    }

    @objc func fire() {
        block()
    }
}

public class SATimer {
    var timer:NSTimer
    public let interval:NSTimeInterval
    public let oneShot:Bool

    init(after interval: NSTimeInterval, action block: () -> Void) {
        let actor = NSTimerActor( block )

        self.oneShot = true
        self.interval = interval
        self.timer = NSTimer(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: false)
    }

    init(every interval: NSTimeInterval, action block: () -> Void) {
        let actor = NSTimerActor( block )

        self.oneShot = false
        self.interval = interval
        self.timer = NSTimer(timeInterval: interval, target: actor, selector: "fire", userInfo: nil, repeats: true)
    }

    public func start(runLoop: NSRunLoop = NSRunLoop.currentRunLoop(), modes: String...) {
        let modes = modes.isEmpty ? [NSDefaultRunLoopMode] : modes

        for mode in modes {
            runLoop.addTimer(timer, forMode: mode)
        }
    }

    public var valid:Bool {
        return timer.valid
    }

    public func stop() {
        timer.invalidate()
    }
}