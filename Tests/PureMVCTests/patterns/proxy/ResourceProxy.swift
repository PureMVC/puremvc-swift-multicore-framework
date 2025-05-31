//
//  TestProxy.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

class ResourceProxy: Proxy {
    
    init(data: Resource) {
        super.init(name: Proxy.NAME, data: data)
    }
    
    deinit {
        (data as! Resource).state = .RELEASED
    }
    
}
