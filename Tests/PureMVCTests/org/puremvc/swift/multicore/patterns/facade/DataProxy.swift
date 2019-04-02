//
//  DataProxy.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

public class DataProxy: Proxy {
    
    public override class var NAME: String { return "DataProxy" }
    
    init() {
        super.init(proxyName: DataProxy.NAME)
    }
    
    public override func onRegister() {
        
    }
    
}
