//
//  Make.swift
//  EffectiveMobileTestTask
//
//  Created by Ruslan Kozlov on 14.11.2024.
//

public func make<T>(_ object: T, using closure: (inout T) -> Void) -> T {
    var object = object
    closure(&object)
    return object
}
