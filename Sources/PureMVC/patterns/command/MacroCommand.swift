//
//  MacroCommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
A base `ICommand` implementation that executes other `ICommand`s.

A `MacroCommand` maintains an list of
`ICommand` Class references called *SubCommands*.

When `execute` is called, the `MacroCommand`
retrieves `ICommands` by executing closures and then calls 
`execute` on each of its *SubCommands* turn.
Each *SubCommand* will be passed a reference to the original
`INotification` that was passed to the `MacroCommand`'s
`execute` method.

Unlike `SimpleCommand`, your subclass
should not override `execute`, but instead, should
override the `initializeMacroCommand` method,
calling `addSubCommand` once for each *SubCommand*
to be executed.

`@see org.puremvc.swift.multicore.core.Controller Controller`

`@see org.puremvc.swift.multicore.patterns.observer.Notification Notification`

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommand SimpleCommand`
*/
open class MacroCommand: Notifier, ICommand {
    
    internal var subCommands: [() -> ICommand] = []
    
    /**
    Constructor.
    
    You should not need to define a constructor,
    instead, override the `initializeMacroCommand`
    method.
    
    If your subclass does define a constructor, be
    sure to call `super()`.
    */
    public override init() {
        super.init()
        initializeMacroCommand()
    }
    
    /**
    Initialize the `MacroCommand`.
    
    In your subclass, override this method to
    initialize the `MacroCommand`'s *SubCommand*
    list with closure references like
    this:

        // Initialize MyMacroCommand
        public func addSubCommand(closure: () -> ICommand) {
            addSubCommand( { FirstCommand() } );
            addSubCommand( { SecondCommand() } );
            addSubCommand( ) { ThirdCommand() }; //or by using a trailing closure
        }
    
    Note that *SubCommands* may be any closure returning `ICommand`
    implementor, `MacroCommands` or `SimpleCommands` are both acceptable.
    */
    open func initializeMacroCommand() {
        
    }
    
    /**
    Add a *SubCommand*.
    
    The *SubCommands* will be called in First In/First Out (FIFO)
    order.
    
    - parameter factory: reference that returns `ICommand`.
    */
    open func addSubCommand(_ factory: @escaping () -> ICommand) {
        subCommands.append(factory)
    }
    
    /**
    Execute this `MacroCommand`'s *SubCommands*.
    
    The *SubCommands* will be called in First In/First Out (FIFO)
    order.
    
    - parameter notification: the `INotification` object to be passsed to each *SubCommand*.
    */
    public final func execute(_ notification: INotification) {
        while (!subCommands.isEmpty) {
            let factory = subCommands.remove(at: 0)
            let commandInstance = factory()
            commandInstance.initializeNotifier(multitonKey!)
            commandInstance.execute(notification)
        }
    }
    
}
