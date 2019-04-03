//
//  ControllerTestCommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

/**
A SimpleCommand subclass used by ControllerTest.

`@see org.puremvc.swift.multicore.core.controller.ControllerTest ControllerTest`

`@see org.puremvc.swift.multicore.core.controller.ControllerTestVO ControllerTestVO`
*/
public class ControllerTestCommand: SimpleCommand {
    
    /**
    Fabricate a result by multiplying the input by 2

    - parameter note: the note carrying the ControllerTestVO
    */
    public override func execute(_ notification: INotification) {
        let vo: ControllerTestVO = notification.body as! ControllerTestVO
        
        // Fabricate a result
        vo.result = 2 * vo.input
    }
    
}
