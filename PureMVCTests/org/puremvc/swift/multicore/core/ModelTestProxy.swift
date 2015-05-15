//
//  ModelTestProxy.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

public class ModelTestProxy: Proxy {
    
    public override class var NAME: String { return "Proxy" }
    
    public class var ON_REGISTER_CALLED: String { return "onRegister Called" }
    public class var ON_REMOVE_CALLED: String { return "onRemove Called" }
    
    public init() {
        super.init(proxyName: ModelTestProxy.NAME, data: nil)
    }
    
    public override func onRegister() {
        self.data = ModelTestProxy.ON_REGISTER_CALLED
    }
    
    public override func onRemove() {
        self.data = ModelTestProxy.ON_REMOVE_CALLED
    }
    
}
