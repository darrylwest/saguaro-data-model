//
//  SAUndoRedo.swift
//  SaguaroDataModel
//
//  Created by darryl west on 8/16/15.
//  Copyright © 2015 darryl west. All rights reserved.
//

import Foundation

public struct SAUndoRedo<T> {
    public let maxSize:Int

    private var undoStack:SAStack<T>
    private var redoStack:SAStack<T>

    public init(maxSize:Int? = 20) {
        self.maxSize = maxSize!
        self.undoStack = SAStack<T>()
        self.redoStack = SAStack<T>()
    }

    /// push a value change to enable undo'ing
    public mutating func pushChange(value:T) -> T {
        return undoStack.push( value )
    }


}
