//
//  FacadeExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

public class FacadeExtend: Facade {
    
    public var resource: Resource?
    
    public override func initializeController() {
        if controller != nil {
            return
        }
        controller = Controller.getInstance(multitonKey) { ControllerExtend(key: self.multitonKey) }
    }
    
    public override func initializeModel() {
        if model != nil {
            return
        }
        model = Model.getInstance(multitonKey) { ModelExtend(key: self.multitonKey) }
    }
    
    public class func getInstance(key: String) -> IFacade {
        return Facade.getInstance(key) { FacadeExtend(key: key) }
    }
    
    public override static func removeCore(_ key: String) {
        Facade.removeCore(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
    
}
