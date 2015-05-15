//
//  ControllerTestVO.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
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
    
    :param: input the number to be fed to the ControllerTestCommand
    */
    public init(input: Int) {
        self.input = input
    }
    
}
