//
//  DispathQueue+After.swift
//  MemoryChainKit
//
//  Created by Marc Zhao on 2019/2/24.
//  Copyright © 2019 Memory Chain technology(China) co,LTD. All rights reserved.
//

import Foundation


public typealias Closure = () ->Void
public extension DispatchQueue {
    static func isExecutedOnMainThread(_ closure:@escaping Closure ) {
        if Thread.isMainThread {
            closure()
        }else {
            main.async(execute: closure)
        }
    }
    class func safeUISync(execute workItem: DispatchWorkItem) {
           if Thread.isMainThread { workItem.perform() }
           else                   { DispatchQueue.main.sync(execute: workItem) }
       }
       
       class func safeUISync<T>(execute work: () throws -> T) rethrows -> T {
           if Thread.isMainThread { return try work() }
           else                   { return try DispatchQueue.main.sync(execute: work) }
       }
       
       class func safeUISync<T>(flags: DispatchWorkItemFlags, execute work: () throws -> T) rethrows -> T {
           if Thread.isMainThread { return try work() }
           else                   { return try DispatchQueue.main.sync(flags: flags, execute: work) }
       }
    private struct Static {
        private static var safeSyncKey = "safeSyncKey"
        private static var syncQueue = DispatchQueue(label: "",attributes: [])
        static func isCurrentQueue(_ queue:DispatchQueue) ->Bool {
            let pointer = unsafeMutablePointer(to:queue)
            syncQueue.sync {
                if __dispatch_queue_get_specific(queue, &safeSyncKey) == nil {
                    __dispatch_queue_set_specific(queue, &safeSyncKey, pointer, nil)
                }

            }
            return __dispatch_get_specific(&safeSyncKey) == pointer

        }
    }
    func safeSync(execute workItem:DispatchWorkItem) {
        if Static.isCurrentQueue(self) {
            workItem.perform()
        }else {
            sync(execute: workItem)
        }
    }
    func safeSync<T>(execute work:() throws ->T) rethrows ->T {
        if Static.isCurrentQueue(self) {
            return try work()
        }else {
            return try sync(execute: work)
        }
    }
    func safeSync<T>(flags:DispatchWorkItemFlags,
                     execute work:()throws ->T)rethrows ->T {
        if Static.isCurrentQueue(self) {
            return try work()
        }else {
            return try sync(flags: flags, execute: work)
        }
    }
}

fileprivate  func unsafeMutablePointer<T:AnyObject>(to object:T)->UnsafeMutableRawPointer {
    return Unmanaged<T>.passUnretained(object).toOpaque()
}
