//
//  ResourceCommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

class ResourceCommand: SimpleCommand {
    
    override func execute(_ notification: INotification) {
        let resource: Resource = notification.body as! Resource
        resource.state = .RELEASED
    }
    
}
