//
//  FacadeTestCommand2.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

public class FacadeTestCommand2: SimpleCommand {
    
    /**
    Fabricate a result by multiplying the input by 2
    *
    - parameter note: the Notification carrying the FacadeTestVO
    */
    public override func execute(_ notification: INotification) {
        
        let vo:FacadeTestVO = notification.body as! FacadeTestVO
        
        //Fabricate a result
        vo.result = 2 * vo.input
        
        facade?.registerMediator(ApplicationMediator())
        facade?.registerProxy(DataProxy())
    }
    
}
