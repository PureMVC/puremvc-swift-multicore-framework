//
//  ICommand.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

/**
The interface definition for a PureMVC Command.

`@see org.puremvc.swift.multicore.interfaces INotification
*/
public protocol ICommand: INotifier {
    
    /**
    Execute the `ICommand`'s logic to handle a given `INotification`.
    
    - parameter notification: an `INotification` to handle.
    */
    func execute(_ notification: INotification)
    
}
