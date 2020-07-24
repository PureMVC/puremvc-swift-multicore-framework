//
//  ICommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
The interface definition for a PureMVC Command.

`@see org.puremvc.swift.multicore.interfaces INotification
*/
public protocol ICommand: INotifier {
    
    /**
    Execute the `ICommand`'s logic to handle a given `INotification`.
    
    - parameter note: an `INotification` to handle.
    */
    func execute(_ notification: INotification)
    
}
