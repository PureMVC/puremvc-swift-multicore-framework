//
//  Mediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
A base `IMediator` implementation.

`@see org.puremvc.swift.multicore.core.View View`
*/
open class Mediator: Notifier, IMediator {
    
    /**
    The name of the `Mediator`.
    
    Typically, a `Mediator` will be written to serve
    one specific control or group controls and so,
    will not have a need to be dynamically named.
    */
    open class var NAME: String { "Mediator" }
    
    // the mediator name
    public private(set) var name: String
    
    // The view component
    public weak var viewComponent: AnyObject?
    
    /**
    Constructor.
    
    - parameter name: the mediator name
    - parameter viewComponent: viewComponent instance
    */
    public init(name: String? = nil, viewComponent: AnyObject? = nil) {
        self.name = name ?? Mediator.NAME
        self.viewComponent = viewComponent
    }
    
    /**
    List the `INotification` names this
    `Mediator` is interested in being notified of.
    
    - returns: Array the list of `INotification` names
    */
    open func listNotificationInterests() -> [String] {
        []
    }
    
    /**
    Handle `INotification`s.
    
    Typically this will be handled in a switch statement,
    with one 'case' entry per `INotification`
    the `Mediator` is interested in.
    */
    open func handleNotification(_ notification: INotification) {
        
    }
    
    /// Called by the View when the Mediator is registered
    open func onRegister() {
        
    }
    
    /// Called by the View when the Mediator is removed
    open func onRemove() {
        
    }

}
