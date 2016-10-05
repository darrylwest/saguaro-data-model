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

    init(_ block: @escaping () -> Void) {
        self.block = block
    }

    @objc func fire() {
        block()
    }
}

open class SATimer {
    var timer:Timer
    open let interval:TimeInterval
    open let oneShot:Bool

    public init(after interval: TimeInterval, action block: @escaping () -> Void) {
        let actor = NSTimerActor( block )

        self.oneShot = true
        self.interval = interval
        self.timer = Timer(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: false)
    }

    public init(every interval: TimeInterval, action block: @escaping () -> Void) {
        let actor = NSTimerActor( block )

        self.oneShot = false
        self.interval = interval
        self.timer = Timer(timeInterval: interval, target: actor, selector: #selector(NSTimerActor.fire), userInfo: nil, repeats: true)
    }

    open func start(_ runLoop: RunLoop = RunLoop.current, modes: String...) {
		let modes = modes.isEmpty ? [RunLoopMode.defaultRunLoopMode] : modes.map { RunLoopMode(rawValue: $0) }

        for mode in modes {
            runLoop.add(timer, forMode: mode)
        }
    }

    open var valid:Bool {
        return timer.isValid
    }

    open func stop() {
        timer.invalidate()
    }
}
