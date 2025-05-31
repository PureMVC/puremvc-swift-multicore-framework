//
//  ControllerTestVO.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

/**
A utility class used by ControllerTest.

`@see org.puremvc.swift.multicore.core.controller.ControllerTest ControllerTest`

`@see org.puremvc.swift.multicore.core.controller.ControllerTestCommand ControllerTestCommand`
*/
public class ControllerTestVO {
    
    var input: Int = 0
    var result: Int = 0
    
    /**
    Constructor.
    
    - parameter input: the number to be fed to the ControllerTestCommand
    */
    public init(input: Int) {
        self.input = input
    }
    
}
