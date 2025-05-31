//
//  ResourceCommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

class ResourceCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        let resource: Resource = notification.body as! Resource
        resource.state = .RELEASED
    }
    
}
