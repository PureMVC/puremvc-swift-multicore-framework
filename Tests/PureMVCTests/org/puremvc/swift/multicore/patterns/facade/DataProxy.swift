//
//  DataProxy.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

public class DataProxy: Proxy {
    
    public override class var NAME: String { return "DataProxy" }
    
    init() {
        super.init(name: DataProxy.NAME)
    }
    
    public override func onRegister() {
        
    }
    
}
