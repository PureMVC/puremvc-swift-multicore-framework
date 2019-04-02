//
//  ModelExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

public class ModelExtend: Model {
    
    public var resource: Resource?
    
    public class func getInstance(key: String) -> IModel {
        return Model.getInstance(key) { ModelExtend(key: key) }
    }
    
    public override class func removeModel(_ key: String) {
        Model.removeModel(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
}
