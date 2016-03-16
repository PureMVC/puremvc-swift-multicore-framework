//
//  ControllerTestCommand2.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A SimpleCommand subclass used by ControllerTest.

`@see org.puremvc.as3.multicore.core.controller.ControllerTest ControllerTest`

`@see org.puremvc.as3.multicore.core.controller.ControllerTestVO ControllerTestVO`
*/
public class ControllerTestCommand2: SimpleCommand {
    
    /**
    Constructor.
    */
    
    public override init() {
        super.init()
    }
    
    /**
    Fabricate a result by multiplying the input by 2 and adding to the existing result
    
    This tests accumulation effect that would show if the command were executed more than once.
    
    - parameter note: the note carrying the ControllerTestVO
    */
    public override func execute(notification: INotification) {
        let vo = notification.body as! ControllerTestVO
        
        // Fabricate a result
        vo.result = vo.result + (2 * vo.input)
    }
    
}
