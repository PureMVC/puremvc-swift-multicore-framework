//
//  ControllerExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

public class ControllerExtend: Controller {
    
    public var resource: Resource?
    
    public override func initializeController() {
        view = View.getInstance(multitonKey) { ViewExtend(key: self.multitonKey) }
    }
    
    public class func getInstance(key: String) -> IController {
        return Controller.getInstance(key) { ControllerExtend(key: key) }
    }
    
    public override class func removeController(key: String) {
        Controller.removeController(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
}
