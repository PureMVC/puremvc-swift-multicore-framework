//
//  MacroCommandTestVO.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

/**
A utility class used by MacroCommandTest.

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTest MacroCommandTest`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestCommand MacroCommandTestCommand`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestSub1Command MacroCommandTestSub1Command`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestSub2Command MacroCommandTestSub2Command`
*/
public class MacroCommandTestVO {
    
    var input: Int
    var result1: Int?
    var result2: Int?
    
    /**
    Constructor.
    *
    - parameter input: the number to be fed to the MacroCommandTestCommand
    */
    init(input: Int) {
        self.input = input
    }
    
}
