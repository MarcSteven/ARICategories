//
//  globalFunc.swift
//  ARICategoryKit
//
//  Created by marc zhao on 2022/3/31.
//

import Foundation




public func getAssociatedObject<T>(_ object:Any,
                            _ key:UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object,key) as? T
    
    
    
}

public func setAssociatedObject(_ object:Any,
                         _ key:UnsafeRawPointer,
                         _ value:Any?) {
    
    return objc_setAssociatedObject(object, key, value, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    
}

public func unsafeMutablePointer<T:AnyObject>(to object:T)->UnsafeMutableRawPointer {
    return Unmanaged<T>.passUnretained(object).toOpaque()
}

