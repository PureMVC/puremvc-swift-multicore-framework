//
//  ResourceMediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

class ResourceMediator: Mediator {
    
    init(view: Resource) {
        super.init(name: Mediator.NAME, view: view)
    }
    
    override func listNotificationInterests() -> [String] {
        return [ "abc", "xyz"]
    }
    
    override func handleNotification(_ notification: INotification) {
        
    }
    
    deinit {
        (view as! Resource).state = .RELEASED
    }
    
}
