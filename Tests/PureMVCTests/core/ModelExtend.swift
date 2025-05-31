//
//  ModelExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

public class ModelExtend: Model {
    
    public var resource: Resource?
    
    public class func getInstance(key: String) -> IModel? {
        return Model.getInstance(key) { key in ModelExtend(key: key) }
    }
    
    public override class func removeModel(_ key: String) {
        Model.removeModel(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
}
