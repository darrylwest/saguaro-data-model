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

    var undoStack:SAStack<T>
    var redoStack:SAStack<T>

    public init(maxSize:Int? = 50) {
        self.maxSize = maxSize!
        self.undoStack = SAStack<T>( capLimit: maxSize )
        self.redoStack = SAStack<T>( capLimit: maxSize )
    }

    /// to total number of available undo's
    public var undoCount:Int {
        return undoStack.count
    }

    /// the total number of redo's available
    public var redoCount:Int {
        return redoStack.count
    }

    /// push a value change to enable undo'ing
    public mutating func save(_ value:T) -> T {
        return undoStack.push( value )
    }

    /// pull the last save/change; if non-nil, save to the redo stack; return a peek at the top of stack
    public mutating func undo() -> T? {
        guard let value = undoStack.pop() else {
            return nil
        }

        redoStack.push( value )

        return value
    }

    /// pull the last redo; if non-nil, save and return it
    public mutating func redo() -> T? {
        guard let value = redoStack.pop() else {
            return nil
        }

        return value
    }

    /// clear both the undo and redo stacks
    public mutating func clearAll() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
}
