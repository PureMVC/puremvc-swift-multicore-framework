//
//  FacadeExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

public class FacadeExtend: Facade {
    
    public var resource: Resource?
    
    public override func initializeController() {
        controller = Controller.getInstance(multitonKey) { key in ControllerExtend(key: key) }
    }
    
    public override func initializeModel() {
        model = Model.getInstance(multitonKey) { key in ModelExtend(key: key) }
    }
    
    public class func getInstance(key: String) -> IFacade? {
        return Facade.getInstance(key) { key in FacadeExtend(key: key) }
    }
    
    public override static func removeCore(_ key: String) {
        Facade.removeCore(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
    
}
