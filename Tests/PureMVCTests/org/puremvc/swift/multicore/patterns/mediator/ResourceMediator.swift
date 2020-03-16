//
//  ResourceMediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

class ResourceMediator: Mediator {
    
    init(viewComponent: Resource) {
        super.init(name: Mediator.NAME, viewComponent: viewComponent)
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
