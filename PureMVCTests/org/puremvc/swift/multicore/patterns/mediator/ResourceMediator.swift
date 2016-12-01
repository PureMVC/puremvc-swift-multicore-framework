//
//  ResourceMediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

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
