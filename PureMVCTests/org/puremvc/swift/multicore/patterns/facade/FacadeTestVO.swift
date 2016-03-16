//
//  FacadeTestVO.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A utility class used by FacadeTest.

`@see org.puremvc.swift.multicore.patterns.facade.FacadeTest FacadeTest`

`@see org.puremvc.swift.multicore.patterns.facade.FacadeTestCommand FacadeTestCommand`
*/
public class FacadeTestVO {
    
    public var input: Int
    public var result: Int = 0
    
    /**
    Constructor.
    
    - parameter input: the number to be fed to the FacadeTestCommand
    */
    public init(input: Int) {
        self.input = input
    }
    
}
