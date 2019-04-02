//
//  ResourceMediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

class ResourceMediator: Mediator {
    
    init(viewComponent: Resource) {
        super.init(mediatorName: Mediator.NAME, viewComponent: viewComponent)
    }
    
    override func listNotificationInterests() -> [String] {
        return [ "abc", "xyz"]
    }
    
    override func handleNotification(_ notification: INotification) {
        
    }
    
    deinit {
        (viewComponent as! Resource).state = .RELEASED
    }
    
}
