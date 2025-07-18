//
//  File.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

/**
A MacroCommand subclass used by MacroCommandTest.

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTest MacroCommandTest`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestSub1Command MacroCommandTestSub1Command`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestSub2Command MacroCommandTestSub2Command`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestVO MacroCommandTestVO`
*/
public class MacroCommandTestCommand: MacroCommand {
    
    /**
    Initialize the MacroCommandTestCommand by adding
    its 2 SubCommands.
    */
    public override func initializeMacroCommand() {
		self.addSubCommand { MacroCommandTestSub1Command() }
		self.addSubCommand { MacroCommandTestSub2Command() }
    }
    
}
