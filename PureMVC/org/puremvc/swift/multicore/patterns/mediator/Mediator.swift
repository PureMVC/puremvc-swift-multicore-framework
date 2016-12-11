//
//  Mediator.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
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
    open class var NAME: String { return "Mediator" }
    
    // the mediator name
    fileprivate var _mediatorName: String
    
    // The view component
    fileprivate var _viewComponent: AnyObject?
    
    /**
    Constructor.
    
    - parameter mediatorName: the mediator name
    - parameter viewComponent: viewComponent instance
    */
    public init(mediatorName: String?=nil, viewComponent: AnyObject?=nil) {
        _mediatorName = mediatorName ?? Mediator.NAME
        _viewComponent = viewComponent
    }
    
    /**
    List the `INotification` names this
    `Mediator` is interested in being notified of.
    
    - returns: Array the list of `INotification` names
    */
    open func listNotificationInterests() -> [String] {
        return []
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
    
    /// Get the name of the `Mediator`.
    open var mediatorName: String {
        return _mediatorName
    }
    
    /// Get or set the `IMediator`'s view component.
    open var viewComponent: AnyObject? {
        get { return _viewComponent }
        set { _viewComponent = newValue }
    }

}
