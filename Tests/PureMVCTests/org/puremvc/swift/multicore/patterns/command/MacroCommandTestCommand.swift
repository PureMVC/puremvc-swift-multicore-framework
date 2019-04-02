//
//  File.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

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
		self.addSubCommand() { MacroCommandTestSub1Command() }
		self.addSubCommand() { MacroCommandTestSub2Command() }
    }
    
}
