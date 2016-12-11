//
//  SimpleCommandTestCommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A SimpleCommand subclass used by SimpleCommandTest.

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommandTest SimpleCommandTest`
`@see org.puremvc.swift.multicore.patterns.command.SimpleCommandTestVO SimpleCommandTestVO`
*/
public class SimpleCommandTestCommand: SimpleCommand {
    
    /**
    Fabricate a result by multiplying the input by 2

    - parameter event: the `INotification` carrying the `SimpleCommandTestVO`
    */
    public override func execute(_ notification: INotification) {
        let vo:SimpleCommandTestVO = notification.body as! SimpleCommandTestVO

        //Fabricate a result
        vo.result = 2 * vo.input
    }
    
}
