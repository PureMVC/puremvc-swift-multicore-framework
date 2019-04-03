//
//  ApplicationMediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

public class ApplicationMediator: Mediator {
    
    public override class var NAME: String { return "ApplicationMediator" }
    
    public init(viewComponent: AnyObject? = nil) {
        super.init(mediatorName: ApplicationMediator.NAME, viewComponent: viewComponent)
    }
    
    public override func onRegister() {
        
    }
    
    public override func listNotificationInterests() -> [String] {
        return [ ShellFacade.TestMediator ]
    }
    
    public override func handleNotification(_ notification: INotification) {
        switch(notification.name) {
            case ShellFacade.TestMediator:
                let vo:FacadeTestVO = notification.body as! FacadeTestVO
                
                //Fabricate a result
                vo.result = vo.input * vo.input
            default:
                return
        }
    }
    
}
