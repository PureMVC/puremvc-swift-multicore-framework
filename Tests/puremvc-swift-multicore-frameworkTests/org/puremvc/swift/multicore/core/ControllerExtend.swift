//
//  ControllerExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

public class ControllerExtend: Controller {
    
    public var resource: Resource?
    
    public override func initializeController() {
        view = View.getInstance(multitonKey) { ViewExtend(key: self.multitonKey) }
    }
    
    public class func getInstance(key: String) -> IController {
        return Controller.getInstance(key) { ControllerExtend(key: key) }
    }
    
    public override class func removeController(_ key: String) {
        Controller.removeController(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
}
